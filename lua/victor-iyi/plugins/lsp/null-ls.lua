local status, null_ls = pcall(require, 'null-ls')
if not status then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- to setup format on save
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

null_ls.setup({
  -- setup formatters and linters
  sources = {
    -- to disable file type use
    -- "formatting.prettier.with({disabled_filetypes: {}}) -- (see null-ls docs)
    formatting.stylua,        -- lua formatter
    formatting.rustfmt,       -- rust formatter
    diagnostics.flake8,       -- python diagnostics
    diagnostics.luacheck,     -- lua diagnostics
    diagnostics.markdownlint, -- markdown styel & syntax checker.
    diagnostics.mypy,         -- Python static type checker.
  },
  -- configure format on save.
  on_attach = function(current_client, bufnr)
    if current_client.supports_method('textDocument/formatting') then

      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              -- only use null-ls for formatting instead of lsp server.
              return client.name == 'null-ls'
            end,
            bufnr = bufnr,
          })
        end,
      })
    end
  end,
})