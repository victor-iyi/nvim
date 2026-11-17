-- AI, on top of Copilot's completions (`plugins/copilot.lua`):
--   * sidekick.nvim     Copilot "next edit suggestions" (multi-line edits after you pause),
--                       plus a terminal for other AI CLIs (Codex, Gemini, OpenCode, ...).
--   * claudecode.nvim   Claude Code's IDE integration: Claude sees your open file and
--                       selection, and its edits open as diffs you accept or reject here.
--   * codecompanion     Chat, inline edits, prompts and agents (Claude Code over ACP), with MCP.
--   * `ai/shell.lua`    Turns "how do I ..." into a shell command typed into the terminal.
-- Every key is under <leader>c, listed in `config/keymaps.lua`.

-- ── Next edit suggestions + AI CLIs ─────────────────────────────────────────────────────

require('sidekick').setup({
  nes = {
    -- Same opt-outs as Copilot's completions, plus `vim.b.sidekick_nes = false`.
    enabled = function(buf)
      return vim.bo[buf].buftype == '' and vim.b[buf].sidekick_nes ~= false
    end,
  },
  cli = {
    picker = 'telescope',
    win = { layout = 'right', split = { width = math.floor(vim.o.columns * 0.4) } },
  },
})

-- ── Claude Code ─────────────────────────────────────────────────────────────────────────

-- Starts a small local server so any `claude` started in this project (here or in another
-- terminal, via `/ide`) can see the editor and open its diffs here.
---@diagnostic disable: missing-fields (the plugin fills in the rest)
require('claudecode').setup({
  log_level = 'warn',
  terminal = {
    provider = 'native',
    show_native_term_exit_tip = false,
    split_side = 'right',
    split_width_percentage = 0.40,
  },
  diff_opts = {
    layout = 'vertical',
    open_in_new_tab = false,
  },
})
---@diagnostic enable: missing-fields

-- ── Chat, inline edits, agents, MCP ─────────────────────────────────────────────────────

-- MCP servers are configured once, for Claude Code (`claude mcp add ...`, or a project's
-- `.mcp.json`), and the local (stdio) ones are shared with CodeCompanion's chats too.
local function claude_mcp_servers()
  local servers = {}

  local function read(path)
    local file = io.open(path, 'r')

    if not file then
      return
    end

    local ok, data = pcall(vim.json.decode, file:read('*a'))
    file:close()

    for name, server in pairs(ok and type(data) == 'table' and data.mcpServers or {}) do
      if server.command and (server.type == nil or server.type == 'stdio') then
        servers[name] = {
          cmd = vim.list_extend({ server.command }, server.args or {}),
          env = server.env,
        }
      end
    end
  end

  read(vim.fs.joinpath(vim.env.HOME, '.claude.json'))

  local root = vim.fs.root(0, '.git')

  if root then
    read(vim.fs.joinpath(root, '.mcp.json'))
  end

  -- Up-to-date library docs on request (`/mcp` in a chat); fetched with npx on first use.
  servers.context7 = servers.context7 or { cmd = { 'npx', '-y', '@upstash/context7-mcp' } }

  return servers
end

local function setup_codecompanion()
  -- The ACP bridge runs the `claude` you already have instead of downloading its own copy.
  if not vim.env.CLAUDE_CODE_EXECUTABLE and vim.fn.executable('claude') == 1 then
    vim.env.CLAUDE_CODE_EXECUTABLE = vim.fn.exepath('claude')
  end

  require('codecompanion').setup({
    -- Copilot's models (included in the subscription) answer chats and inline edits;
    -- `<leader>cA` opens a chat with the Claude Code agent instead.
    interactions = {
      chat = { adapter = 'copilot' },
      inline = { adapter = 'copilot' },
      cmd = { adapter = 'copilot' },
    },
    mcp = {
      servers = claude_mcp_servers(),
    },
    display = {
      action_palette = { provider = 'telescope' },
      chat = {
        window = {
          layout = 'vertical',
          position = 'right',
          width = 0.4,
        },
      },
    },
  })
end

-- After the first screen is drawn, so it never slows startup.
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.schedule(setup_codecompanion)
  end,
})

-- In the Claude panel, <C-h> goes straight back to the code on the left (Claude keeps
-- running); <leader>cf or `i` in its window takes you back in.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'claudecode',
  callback = function(ev)
    vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { buffer = ev.buf, desc = 'Claude: back to code' })
  end,
})

-- `<leader>cs` in the file tree adds the file under the cursor to Claude's context.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'NvimTree', 'nerdtree' },
  callback = function(ev)
    vim.keymap.set('n', '<leader>cs', '<cmd>ClaudeCodeTreeAdd<CR>', { buffer = ev.buf, desc = 'Claude: add file' })
  end,
})

-- In the shell opened with <leader>ft (not lazygit): <C-g> asks for a command and types it
-- in, without running it.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'toggleterm',
  callback = function(ev)
    if vim.api.nvim_buf_get_name(ev.buf):find('lazygit', 1, true) then
      return
    end

    vim.keymap.set('t', '<C-g>', function()
      require('ai.shell').ask({ buf = ev.buf })
    end, { buffer = ev.buf, desc = 'AI: suggest a shell command' })
  end,
})
