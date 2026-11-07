-- Formatting with formatter.nvim: `:Format` (<leader>f), `:FormatWrite` (<leader>F), and
-- format-on-save.
local util = require('formatter.util')
local ft = function(lang)
  return require('formatter.filetypes.' .. lang)
end

local function stylua()
  return {
    exe = 'stylua',
    args = {
      '--search-parent-directories',
      '--stdin-filepath',
      util.escape_path(util.get_current_buffer_file_path()),
      '--quote-style=AutoPreferSingle',
      '--indent-width=2',
      '--indent-type=Spaces',
      '--',
      '-',
    },
    stdin = true,
  }
end

-- Each flag and value is its own argv entry; a single '--edition 2021' string made
-- rustfmt reject the call.
local function rustfmt()
  return {
    exe = 'rustfmt',
    args = { '--edition', '2021', '--config', 'tab_spaces=2', '--emit', 'stdout' },
    stdin = true,
  }
end

-- The file path lets ruff find the project's pyproject.toml settings and excludes.
local function ruff()
  return {
    exe = 'ruff',
    args = { 'format', '-q', '--stdin-filename', util.escape_path(util.get_current_buffer_file_path()), '-' },
    stdin = true,
  }
end

local prettier = ft('javascript').prettierd

require('formatter').setup({
  logging = false,
  log_level = vim.log.levels.WARN,
  filetype = {
    lua = { stylua },
    rust = { rustfmt },
    python = { ruff },
    go = { ft('go').goimports, ft('go').gofumpt },
    javascript = { prettier },
    javascriptreact = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    json = { prettier },
    jsonc = { prettier },
    yaml = { prettier },
    markdown = { prettier },
    css = { prettier },
    html = { prettier },
    sh = { ft('sh').shfmt },
    bash = { ft('sh').shfmt },
    toml = { ft('toml').taplo },
  },
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('config.format', { clear = true }),
  desc = 'Format after save',
  command = 'FormatWrite',
})
