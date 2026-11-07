-- Editor-wide autocommands.
local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup('config.' .. name, { clear = true })
end

-- Replaces vim-highlightedyank.
autocmd('TextYankPost', {
  group = augroup('yank'),
  desc = 'Flash the yanked region',
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

autocmd('BufReadPost', {
  group = augroup('last_position'),
  desc = 'Reopen files where you left off',
  callback = function(ev)
    local excluded = { gitcommit = true, gitrebase = true }
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')

    if excluded[vim.bo[ev.buf].filetype] or vim.b[ev.buf].last_position_done then
      return
    end

    vim.b[ev.buf].last_position_done = true

    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- tmux sends focus events (with `focus-events on`), so edits made in another pane show up.
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  desc = 'Reload files changed outside Neovim',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd.checktime()
    end
  end,
})

autocmd('VimResized', {
  group = augroup('resize'),
  desc = 'Keep splits equal when the terminal or tmux pane resizes',
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd.tabnext(tab)
  end,
})

autocmd('FileType', {
  group = augroup('close_with_q'),
  desc = 'Close read-only helper windows with q',
  pattern = { 'help', 'qf', 'checkhealth', 'man', 'lspinfo', 'notify', 'startuptime', 'dap-float', 'git' },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = ev.buf, silent = true, nowait = true })
  end,
})

autocmd('BufWritePre', {
  group = augroup('mkdir'),
  desc = 'Create missing parent directories on save',
  callback = function(ev)
    if ev.match:match('^%w%w+:[\\/][\\/]') then
      return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(ev.match) or ev.match, ':p:h'), 'p')
  end,
})

autocmd('TermOpen', {
  group = augroup('terminal'),
  desc = 'Clean terminal buffers',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.cursorline = false
  end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup('math_notes'),
  desc = 'Expand $ to $$ in math notes',
  pattern = '*/.math_notes/*',
  command = 'iabbrev <buffer> $ $$',
})
