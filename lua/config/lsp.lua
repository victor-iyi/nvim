-- Native LSP. Base configs come from nvim-lspconfig's `lsp/` files; overrides live in
-- `after/lsp/<server>.lua`. Rust is not listed: rustaceanvim owns rust-analyzer.
local M = {}

-- Python (basedpyright for types, ruff for lint/format), Lua, TypeScript, Go, and friends.
M.servers = {
  'basedpyright',
  'ruff',
  'lua_ls',
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
}

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Servers whose lspconfig `cmd` is a function, so the binary can't be read from it.
local binaries = {
  eslint = 'vscode-eslint-language-server',
  jsonls = 'vscode-json-language-server',
  yamlls = 'yaml-language-server',
}

-- Missing binaries would otherwise raise an error per buffer until Mason installs them.
local function is_installed(name)
  local cmd = vim.lsp.config[name] and vim.lsp.config[name].cmd
  local binary = binaries[name] or (type(cmd) == 'table' and cmd[1])

  return binary and vim.fn.executable(binary) == 1 or false
end

--- Enable every configured server whose executable is on PATH; safe to call repeatedly.
function M.enable_installed()
  vim.lsp.enable(vim.tbl_filter(is_installed, M.servers))
end

M.enable_installed()

-- Prefer declaration (the old `gd`), but most Python and Lua servers only answer
-- definition requests, so fall back instead of erroring.
local function goto_declaration()
  if #vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/declaration' }) > 0 then
    vim.lsp.buf.declaration()
  else
    vim.lsp.buf.definition()
  end
end

local function jump_error(direction)
  return function()
    local saga = require('lspsaga.diagnostic')
    local opts = { severity = vim.diagnostic.severity.ERROR }

    if direction > 0 then
      saga:goto_next(opts)
    else
      saga:goto_prev(opts)
    end
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('config.lsp', { clear = true }),
  desc = 'LSP buffer keymaps',
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = 'LSP: ' .. desc })
    end

    -- Same keys as the previous config.
    map('n', 'gf', '<cmd>Lspsaga finder<CR>', 'finder (definition, references, implementations)')
    map({ 'n', 'x' }, '<leader>a', '<cmd>Lspsaga code_action<CR>', 'code action')
    map('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', 'rename')
    map('n', 'gD', '<cmd>Lspsaga peek_definition<CR>', 'peek definition')
    map('n', 'gd', goto_declaration, 'go to declaration')
    map('n', 'gi', vim.lsp.buf.implementation, 'go to implementation')
    map('n', '<leader>dl', '<cmd>Lspsaga show_line_diagnostics<CR>', 'line diagnostics')
    map('n', '<leader>dc', '<cmd>Lspsaga show_cursor_diagnostics<CR>', 'cursor diagnostics')
    map('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'previous diagnostic')
    map('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', 'next diagnostic')
    map('n', '[e', jump_error(-1), 'previous error')
    map('n', ']e', jump_error(1), 'next error')
    map('n', '<leader>o', '<cmd>Lspsaga outline<CR>', 'outline')
    map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', 'hover documentation')

    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })

      map('n', '<leader>ih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
      end, 'toggle inlay hints')
    end
  end,
})

return M
