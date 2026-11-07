-- LSP companions: Mason (installs servers and tools), lspsaga (UI), Trouble (lists).
-- Native client setup is in `config/lsp.lua`.
local has_ui = #vim.api.nvim_list_uis() > 0

require('mason').setup({
  ui = {
    icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
  },
})

-- Servers Mason keeps installed (lspconfig names). rust_analyzer is used by rustaceanvim.
require('mason-lspconfig').setup({
  ensure_installed = {
    'basedpyright',
    'ruff',
    'lua_ls',
    'rust_analyzer',
    'vtsls',
    'eslint',
    'gopls',
    'bashls',
    'clangd',
    'dockerls',
    'docker_compose_language_service',
    'jsonls',
    'yamlls',
    'taplo',
    'marksman',
  },
  -- Enabling is explicit in `config/lsp.lua` so rust-analyzer isn't started twice.
  automatic_enable = false,
})

-- Formatters, debuggers and CLIs that aren't language servers (Mason package names).
local tools = {
  'stylua',
  'prettierd',
  'shfmt',
  'goimports',
  'gofumpt',
  'codelldb',
  'debugpy',
  'tree-sitter-cli',
}

local function ensure_tools()
  local registry = require('mason-registry')

  registry.refresh(function()
    for _, name in ipairs(tools) do
      local ok, pkg = pcall(registry.get_package, name)

      if ok and not pkg:is_installed() and not pkg:is_installing() then
        pkg:install()
      end
    end
  end)

  -- Newly installed servers attach to already-open buffers without a restart.
  registry:on(
    'package:install:success',
    vim.schedule_wrap(function()
      require('config.lsp').enable_installed()
    end)
  )
end

if has_ui then
  vim.schedule(ensure_tools)
end

-- ── lspsaga ─────────────────────────────────────────────────────────────────────────────

require('lspsaga').setup({
  ui = { border = 'rounded', code_action = '󰌵' },
  symbol_in_winbar = { enable = true, separator = ' \u{f054} ', show_file = true, folder_level = 1 },
  lightbulb = { enable = true, sign = true, virtual_text = false },
  -- <CR> opens from the finder and the definition preview, as before.
  finder = { keys = { toggle_or_open = '<CR>' } },
  definition = { keys = { edit = '<CR>' } },
  outline = { win_width = 35, auto_preview = false },
  hover = { open_link = 'gx' },
  -- Floating terminal is toggleterm's job.
  floaterm = { height = 0.8, width = 0.85 },
  beacon = { enable = true },
})

-- ── Trouble ─────────────────────────────────────────────────────────────────────────────

require('trouble').setup({ focus = true })

local map = vim.keymap.set

map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Trouble: workspace diagnostics' })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Trouble: buffer diagnostics' })
map('n', '<leader>xq', '<cmd>Trouble qflist toggle<CR>', { desc = 'Trouble: quickfix' })
map('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>', { desc = 'Trouble: location list' })
