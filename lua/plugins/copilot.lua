-- GitHub Copilot through Neovim's own LSP client:
--   * ghost-text completions as you type (`vim.lsp.inline_completion`), and
--   * multi-line "next edit suggestions" after you pause (sidekick.nvim, `plugins/ai.lua`).
-- Keys (<C-l>, <C-]>, <C-[>, <C-k> in insert mode; <Tab> in normal mode) are in
-- `config/keymaps.lua`. Sign in once with `:Copilot setup`.

-- Buffers that never get suggestions.
local excluded = {
  TelescopePrompt = true,
  ['dap-repl'] = true,
  dashboard = true,
  NvimTree = true,
  nerdtree = true,
  undotree = true,
  codecompanion = true,
}

-- The language server ships inside copilot.vim (installed, never loaded: see
-- `config/pack.lua`), so it updates with `vim.pack.update()` and needs no extra download.
-- A `copilot-language-server` on PATH (e.g. from Mason) wins if there is one.
local function server_cmd()
  if vim.fn.executable('copilot-language-server') == 1 then
    return { 'copilot-language-server', '--stdio' }
  end

  local js = vim.fs.joinpath(
    vim.fn.stdpath('data'),
    'site/pack/core/opt/copilot.vim/copilot-language-server/dist/language-server.js'
  )

  if vim.fn.executable('node') == 1 and vim.uv.fs_stat(js) then
    return { 'node', js, '--stdio' }
  end
end

local cmd = server_cmd()

if not cmd then
  vim.notify('Copilot: no language server found (needs node and copilot.vim)', vim.log.levels.WARN)
  return
end

vim.lsp.config('copilot', {
  cmd = cmd,
  -- Attach to real files only, in their git root (or the working directory).
  root_dir = function(bufnr, on_dir)
    if vim.bo[bufnr].buftype ~= '' or excluded[vim.bo[bufnr].filetype] then
      return
    end

    on_dir(vim.fs.root(bufnr, '.git') or vim.fn.getcwd())
  end,
})

vim.lsp.enable('copilot')
vim.lsp.inline_completion.enable()

-- `:Copilot setup|signout|status|enable|disable`, as with copilot.vim.
local function copilot_client()
  return vim.lsp.get_clients({ name = 'copilot', bufnr = 0 })[1] or vim.lsp.get_clients({ name = 'copilot' })[1]
end

local actions = {
  setup = function()
    if not copilot_client() then
      vim.notify('Copilot: open a file first, so the server can start', vim.log.levels.WARN)
      return
    end

    -- The commands are buffer-local to wherever the client is attached.
    if vim.fn.exists(':LspCopilotSignIn') == 2 then
      vim.cmd('LspCopilotSignIn')
    else
      vim.notify('Copilot: run :Copilot setup from a file buffer', vim.log.levels.WARN)
    end
  end,
  signout = function()
    if vim.fn.exists(':LspCopilotSignOut') == 2 then
      vim.cmd('LspCopilotSignOut')
    end
  end,
  status = function()
    local status = require('sidekick.status').get()
    local client = copilot_client()

    local lines = {
      ('Server:      %s'):format(client and 'running' or 'not running'),
      ('Status:      %s'):format(
        status and (status.kind .. (status.message and (' - ' .. status.message) or '')) or 'unknown'
      ),
      ('Completions: %s'):format(vim.lsp.inline_completion.is_enabled() and 'on' or 'off'),
      ('Next edits:  %s'):format(require('sidekick.nes').enabled and 'on' or 'off'),
    }

    vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'Copilot' })
  end,
  enable = function()
    vim.lsp.inline_completion.enable(true)
  end,
  disable = function()
    vim.lsp.inline_completion.enable(false)
  end,
}

actions.signin = actions.setup

vim.api.nvim_create_user_command('Copilot', function(opts)
  local action = actions[opts.args ~= '' and opts.args or 'status']

  if action then
    action()
  else
    vim.notify('Copilot: unknown command ' .. opts.args, vim.log.levels.WARN)
  end
end, {
  nargs = '?',
  desc = 'Copilot: setup, signout, status, enable, disable',
  complete = function()
    return { 'setup', 'signout', 'status', 'enable', 'disable' }
  end,
})
