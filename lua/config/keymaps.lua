-- Every global mapping lives here so parity with the previous config is auditable in
-- one file. Buffer-local LSP maps are in `config/lsp.lua`; plugin-internal maps (cmp
-- menu, telescope prompt, nvim-tree buffer) stay with their plugin.
--
-- Maps that type a printable key use `x` (visual only) instead of `v` (visual + select):
-- identical in visual mode, but typing over a snippet placeholder (select mode) no
-- longer pastes or moves lines.
local map = vim.keymap.set

-- Calls `fn` on a module only when the key is pressed, so mapping it costs nothing at startup.
local function lazy(module, fn, ...)
  local args = { ... }

  return function()
    require(module)[fn](unpack(args))
  end
end

-- ── General ─────────────────────────────────────────────────────────────────────────────

map({ 'i', 'v' }, '<C-j>', '<Esc>', { desc = 'Escape' })
map('v', '<C-k>', '<Esc>', { desc = 'Escape' }) -- Insert-mode <C-k> is the Copilot map below.
map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
map('n', '<leader>r', '<cmd>e!<CR>', { desc = 'Reload file' })

map('', 'H', '^', { desc = 'Start of line' })
map('', 'L', '$', { desc = 'End of line' })

-- Arrow keys are off in insert mode; in normal mode left/right switch buffers.
map({ 'i', 'n' }, '<Up>', '<Nop>')
map({ 'i', 'n' }, '<Down>', '<Nop>')
map('i', '<Left>', '<Nop>')
map('i', '<Right>', '<Nop>')
map({ '', 'i' }, '<F1>', '<Nop>')

-- ── Clipboard & registers ───────────────────────────────────────────────────────────────

map('x', '<leader>y', '"+y', { desc = 'Yank to clipboard' })
map('n', '<leader>p', '"+p', { desc = 'Paste from clipboard' })
map('n', '<leader>P', '"+P', { desc = 'Paste from clipboard (before)' })
-- Native visual `P` is the old `"_dP` without its end-of-line bug (it pasted one column early).
map('x', 'p', 'P', { desc = 'Paste without yanking selection' })
map('x', 'P', '"0P', { desc = 'Paste last yank' })
map('n', 'x', '"_x', { desc = 'Delete char without yanking' })

-- ── Buffers ─────────────────────────────────────────────────────────────────────────────

map('n', '<leader><leader>', '<C-^>', { desc = 'Alternate buffer' })
map('n', '<Left>', '<cmd>bp<CR>', { desc = 'Previous buffer' })
map('n', '<Right>', '<cmd>bn<CR>', { desc = 'Next buffer' })

-- ── Search & scrolling (keep the cursor centred) ────────────────────────────────────────

map('n', 'n', 'nzz', { silent = true })
map('n', 'N', 'Nzz', { silent = true })
map('n', '*', '*zz', { silent = true })
map('n', '#', '#zz', { silent = true })
map('n', 'g*', 'g*zz', { silent = true })
map('n', '<C-d>', '<C-d>zz', { silent = true })
map('n', '<C-u>', '<C-u>zz', { silent = true })
map('x', '<leader>=', '<C-W><C-=>', { desc = 'Equalize windows' })
map('n', '<leader>nh', '<cmd>nohl<CR>', { desc = 'Clear search highlight' })

-- ── Numbers ─────────────────────────────────────────────────────────────────────────────

map('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
map('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

-- ── Windows & tabs ──────────────────────────────────────────────────────────────────────

map('n', '<leader>sv', '<C-w>v', { desc = 'Split vertically' })
map('n', '<leader>sh', '<C-w>s', { desc = 'Split horizontally' })
map('n', '<leader>se', '<C-w>=', { desc = 'Equalize splits' })
map('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close split' })
map('n', '<leader>sm', '<cmd>MaximizerToggle!<CR>', { desc = 'Maximize/restore split' })

map('n', '<leader>v+', '<cmd>vertical resize +5<CR>', { silent = true, desc = 'Widen split' })
map('n', '<leader>v-', '<cmd>vertical resize -6<CR>', { silent = true, desc = 'Narrow split' })
map('n', '<leader>vr', '<cmd>vertical resize 30<CR>', { silent = true, desc = 'Reset split width' })

map('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close tab' })
map('n', '<leader>tn', '<cmd>tabnext<CR>', { desc = 'Next tab' })
map('n', '<leader>tp', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })

-- Window/pane navigation (<C-h/j/k/l>, <C-\>) comes from vim-tmux-navigator's defaults.

-- ── Editing ─────────────────────────────────────────────────────────────────────────────

map('x', 'J', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move selection down' })
map('x', 'K', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move selection up' })

-- ── Files & search ──────────────────────────────────────────────────────────────────────

map('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'File tree' })
map('n', '<leader>pt', '<cmd>NERDTreeToggle<CR>', { desc = 'NERDTree' })
map('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Undo tree' })

map('n', '<leader>ff', lazy('telescope.builtin', 'find_files'), { desc = 'Find files' })
map('n', '<leader>fs', lazy('telescope.builtin', 'live_grep'), { desc = 'Find string in project' })
map('n', '<leader>fc', lazy('telescope.builtin', 'grep_string'), { desc = 'Find word under cursor' })
map('n', '<leader>fb', lazy('telescope.builtin', 'buffers'), { desc = 'Find buffers' })
map('n', '<leader>fh', lazy('telescope.builtin', 'help_tags'), { desc = 'Find help' })

-- ── Formatting ──────────────────────────────────────────────────────────────────────────

map('n', '<leader>f', '<cmd>Format<CR>', { silent = true, desc = 'Format buffer' })
map('n', '<leader>F', '<cmd>FormatWrite<CR>', { silent = true, desc = 'Format and write' })

-- ── Terminal (<leader>ft is toggleterm's open_mapping, see plugins/terminal.lua) ────────

-- ── GitHub Copilot (Neovim's inline completion, see plugins/copilot.lua) ────────────────

-- Ghost text is drawn as extmarks in this namespace while a suggestion is showing.
local inline_ns = vim.api.nvim_create_namespace('nvim.lsp.inline_completion')

local function copilot_visible()
  return #vim.api.nvim_buf_get_extmarks(0, inline_ns, 0, -1, { limit = 1 }) > 0
end

-- Returns the keys to run in place, so a fast `<Esc>:w` or a macro keeps its key order.
local function copilot_or_escape(lua)
  return function()
    return copilot_visible() and ('<Cmd>lua %s<CR>'):format(lua) or '<Esc>'
  end
end

-- Accept; with no suggestion showing, a newline (as before).
map('i', '<C-l>', function()
  return vim.lsp.inline_completion.get() and '' or '<CR>'
end, { expr = true, silent = true, desc = 'Copilot: accept' })

map('i', '<C-]>', function()
  vim.lsp.inline_completion.select({ count = 1 })
end, { silent = true, desc = 'Copilot: next' })

-- <C-k> and <C-[> are also Escape: they act on Copilot only while a suggestion is
-- showing, and escape otherwise. (<C-[> *is* <Esc> to the terminal.) Dismissing is
-- "accept, but apply nothing".
map('i', '<C-k>', copilot_or_escape('vim.lsp.inline_completion.get({ on_accept = function() end })'), {
  expr = true,
  silent = true,
  desc = 'Copilot: dismiss / Escape',
})
map('i', '<C-[>', copilot_or_escape('vim.lsp.inline_completion.select({ count = -1 })'), {
  expr = true,
  silent = true,
  desc = 'Copilot: previous / Escape',
})

-- Next edit suggestions (sidekick): <Tab> jumps to the suggested edit, then applies it.
-- With none pending it is plain <Tab> (= <C-i>, jump forward), as before.
map('n', '<Tab>', function()
  return require('sidekick').nes_jump_or_apply() and '' or '<Tab>'
end, { expr = true, desc = 'Copilot: jump to / apply next edit' })

-- ── AI (plugins/ai.lua). <leader>a stays LSP code action. ───────────────────────────────

-- Claude Code, in a split on the right. Its edits open as diffs: accept or reject them here.
map('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Claude: toggle' })
map('n', '<leader>cf', '<cmd>ClaudeCodeFocus<CR>', { desc = 'Claude: focus' })
map('n', '<leader>cr', '<cmd>ClaudeCode --resume<CR>', { desc = 'Claude: resume a session' })
map('n', '<leader>cC', '<cmd>ClaudeCode --continue<CR>', { desc = 'Claude: continue last session' })
map('n', '<leader>cm', '<cmd>ClaudeCodeSelectModel<CR>', { desc = 'Claude: choose model' })
map('n', '<leader>cb', '<cmd>ClaudeCodeAdd %<CR>', { desc = 'Claude: add this file' })
map('x', '<leader>cs', '<cmd>ClaudeCodeSend<CR>', { desc = 'Claude: send selection' })
map('n', '<leader>cy', '<cmd>ClaudeCodeDiffAccept<CR>', { desc = 'Claude: accept diff' })
map('n', '<leader>cd', '<cmd>ClaudeCodeDiffDeny<CR>', { desc = 'Claude: reject diff' })

-- Chat and inline edits (CodeCompanion; Copilot's models, or the Claude Code agent).
map('n', '<leader>ca', '<cmd>CodeCompanionChat Toggle<CR>', { desc = 'AI: chat' })
map('x', '<leader>ca', '<cmd>CodeCompanionChat Add<CR>', { desc = 'AI: add selection to chat' })
map('n', '<leader>cA', '<cmd>CodeCompanionChat adapter=claude_code<CR>', { desc = 'AI: chat with Claude Code agent' })
map({ 'n', 'x' }, '<leader>ci', ':CodeCompanion ', { desc = 'AI: inline edit (type a request)' })
map({ 'n', 'x' }, '<leader>cp', '<cmd>CodeCompanionActions<CR>', { desc = 'AI: prompts & actions' })
map('x', '<leader>ce', ':CodeCompanion /explain<CR>', { silent = true, desc = 'AI: explain selection' })
map('x', '<leader>cx', ':CodeCompanion /fix<CR>', { silent = true, desc = 'AI: fix selection' })
map('n', '<leader>c:', ':CodeCompanionCmd ', { desc = 'AI: describe a Neovim command' })

-- Forgot a shell command? Describe it; it is typed into the <leader>ft terminal (not run).
-- Inside that terminal the same is on <C-g>.
map('n', '<leader>c?', lazy('ai.shell', 'ask'), { desc = 'AI: suggest a shell command' })

-- Copilot next edits on/off, and other AI CLIs (Codex, Gemini, OpenCode, ...) if installed.
map('n', '<leader>cn', '<cmd>Sidekick nes toggle<CR>', { desc = 'AI: toggle next edit suggestions' })
map('n', '<leader>ct', function()
  require('sidekick.cli').select({ filter = { installed = true } })
end, { desc = 'AI: open an AI CLI' })
