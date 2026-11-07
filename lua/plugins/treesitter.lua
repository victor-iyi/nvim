-- Treesitter: highlighting, folds, text objects. nvim-treesitter's `main` branch only
-- installs parsers; Neovim core does the rest.
local ts = require('nvim-treesitter')

local ensure_installed = {
  'bash',
  'c',
  'cpp',
  'css',
  'diff',
  'dockerfile',
  'git_config',
  'git_rebase',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'json5',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'sql',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

-- Parser builds need the `tree-sitter` CLI (Mason installs it on first start).
local function can_build()
  return vim.fn.executable('tree-sitter') == 1
end

local function install_missing()
  if not can_build() or #vim.api.nvim_list_uis() == 0 then
    return
  end

  local installed = ts.get_installed()
  local missing = vim.tbl_filter(function(lang)
    return not vim.list_contains(installed, lang)
  end, ensure_installed)

  if #missing > 0 then
    ts.install(missing, { summary = true })
  end
end

vim.schedule(install_missing)

-- Languages already tried this session, so a failed build isn't retried on every buffer.
local attempted = {}

-- Like the old `auto_install = true`: fetch a parser the first time its filetype opens.
local function auto_install(lang)
  if attempted[lang] or not can_build() then
    return
  end

  attempted[lang] = true

  if vim.list_contains(ts.get_available(), lang) then
    ts.install({ lang })
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config.treesitter', { clear = true }),
  desc = 'Start treesitter highlighting',
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)

    if not lang then
      return
    end

    if not vim.treesitter.language.add(lang) then
      return auto_install(lang)
    end

    pcall(vim.treesitter.start, ev.buf, lang)
  end,
})

-- ── Text objects ────────────────────────────────────────────────────────────────────────

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local select = require('nvim-treesitter-textobjects.select')
local move = require('nvim-treesitter-textobjects.move')

for lhs, query in pairs({
  af = '@function.outer',
  ['if'] = '@function.inner',
  ac = '@class.outer',
  ic = '@class.inner',
  aa = '@parameter.outer',
  ia = '@parameter.inner',
}) do
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    select.select_textobject(query, 'textobjects')
  end, { desc = 'Treesitter ' .. query })
end

-- ]m / [m already mean "next/previous method" in Vim; this makes them language-aware.
local moves = {
  [']m'] = { move.goto_next_start, '@function.outer' },
  ['[m'] = { move.goto_previous_start, '@function.outer' },
  [']M'] = { move.goto_next_end, '@function.outer' },
  ['[M'] = { move.goto_previous_end, '@function.outer' },
}

for lhs, spec in pairs(moves) do
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    spec[1](spec[2], 'textobjects')
  end, { desc = 'Treesitter ' .. spec[2] })
end

-- ── Companions ──────────────────────────────────────────────────────────────────────────

require('nvim-ts-autotag').setup()
