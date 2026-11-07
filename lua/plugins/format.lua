-- Formatting with formatter.nvim: `:Format` (<leader>f), `:FormatWrite` (<leader>F), and
-- format-on-save.
local util = require('formatter.util')
local ft = function(lang)
  return require('formatter.filetypes.' .. lang)
end

-- Nearest file named one of `names`, searching up from the current buffer.
local function find_up(names)
  local dir = vim.fs.dirname(util.get_current_buffer_file_path())

  return vim.fs.find(names, { path = dir, upward = true, type = 'file', limit = 1 })[1]
end

-- Command-line style flags override stylua.toml, so they're only the fallback for
-- projects without one.
local function stylua()
  local args =
    { '--search-parent-directories', '--stdin-filepath', util.escape_path(util.get_current_buffer_file_path()) }

  if not find_up({ 'stylua.toml', '.stylua.toml' }) then
    vim.list_extend(args, { '--quote-style=AutoPreferSingle', '--indent-width=2', '--indent-type=Spaces' })
  end

  return { exe = 'stylua', args = vim.list_extend(args, { '--', '-' }), stdin = true }
end

-- The crate's edition, walking up to the workspace root for `edition.workspace = true`.
local function cargo_edition()
  local dir = vim.fs.dirname(util.get_current_buffer_file_path())

  for _, manifest in ipairs(vim.fs.find('Cargo.toml', { path = dir, upward = true, type = 'file', limit = math.huge })) do
    for line in io.lines(manifest) do
      local edition = line:match('^%s*edition%s*=%s*"(%d+)"')

      if edition then
        return edition
      end
    end
  end
end

-- On macOS rustfmt looks in ~/Library/Application Support, never ~/.config, so the
-- dotfiles' global rustfmt.toml has to be passed explicitly.
local global_rustfmt =
  vim.fs.joinpath(vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(vim.env.HOME, '.config'), 'rustfmt', 'rustfmt.toml')

-- A project rustfmt.toml wins; otherwise the global one. The edition comes from
-- Cargo.toml so 2024-only syntax parses.
local function rustfmt()
  local args = { '--emit', 'stdout' }
  local config = find_up({ 'rustfmt.toml', '.rustfmt.toml' }) or (vim.uv.fs_stat(global_rustfmt) and global_rustfmt)
  local edition = cargo_edition()

  if config then
    vim.list_extend(args, { '--config-path', config })
  end

  if edition then
    vim.list_extend(args, { '--edition', edition })
  end

  return { exe = 'rustfmt', args = args, stdin = true }
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
