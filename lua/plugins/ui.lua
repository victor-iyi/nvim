-- Colorscheme, icons, statusline.

-- nightfly with the terminal's background showing through, as before.
vim.g.nightflyTransparent = true
vim.g.nightflyNormalFloat = true
vim.g.nightflyVirtualTextColor = true
vim.g.nightflyWinSeparator = 2
vim.g.nightflyUndercurls = true

if not pcall(vim.cmd.colorscheme, 'nightfly') then
  vim.notify('colorscheme nightfly not found', vim.log.levels.WARN)
end

require('nvim-web-devicons').setup({ color_icons = true })

-- ── Statusline ──────────────────────────────────────────────────────────────────────────

local theme = require('lualine.themes.nightfly')
local colors = {
  blue = '#65D1FF',
  green = '#3EFFDC',
  violet = '#FF61EF',
  yellow = '#FFDA7B',
  black = '#000000',
}

theme.normal.a.bg = colors.blue
theme.insert.a.bg = colors.green
theme.visual.a.bg = colors.violet
theme.command = { a = { gui = 'bold', bg = colors.yellow, fg = colors.black } }

-- Copilot (dimmed while busy, red on errors such as "not signed in") and Claude Code
-- (shown while a Claude session is connected to this editor).
local copilot = {
  function()
    return '\u{f4b8}'
  end,
  cond = function()
    return package.loaded['sidekick'] ~= nil and require('sidekick.status').get() ~= nil
  end,
  color = function()
    local status = require('sidekick.status').get()

    return status and (status.kind == 'Error' and 'DiagnosticError' or status.busy and 'DiagnosticWarn' or 'Special')
      or nil
  end,
}

local claude = {
  function()
    return '\u{f0b79} Claude'
  end,
  cond = function()
    local ok, claudecode = pcall(require, 'claudecode')

    return ok and claudecode.is_claude_connected()
  end,
  color = 'Special',
}

require('lualine').setup({
  options = {
    theme = theme,
    globalstatus = true,
    component_separators = { left = '\u{e0b5}', right = '\u{e0b7}' },
    section_separators = { left = '\u{e0b4}', right = '\u{e0b6}' },
    disabled_filetypes = { statusline = { 'NvimTree', 'nerdtree', 'undotree' } },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
      { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' \u{f023}', unnamed = '[No Name]' } },
    },
    lualine_x = {
      vim.ui.progress_status,
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
      claude,
      copilot,
      -- Spinner while a server is still indexing (rust-analyzer can take minutes on a big
      -- workspace, and answers nothing until then), ✓ once it is ready.
      { 'lsp_status', icon = '\u{f085}' },
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  extensions = { 'nvim-tree', 'fugitive', 'quickfix', 'toggleterm', 'trouble', 'man' },
})
