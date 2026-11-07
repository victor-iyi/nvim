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

local function lsp_clients()
  local names = vim.tbl_map(function(client)
    return client.name
  end, vim.lsp.get_clients({ bufnr = 0 }))

  return #names > 0 and '\u{f085} ' .. table.concat(names, ' ') or ''
end

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
      { lsp_clients },
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  extensions = { 'nvim-tree', 'fugitive', 'quickfix', 'toggleterm', 'trouble', 'man' },
})
