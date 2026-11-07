-- Python lint, format and import sorting (settings carried over from the previous config).

---@type vim.lsp.Config
return {
  init_options = {
    settings = {
      lint = { enable = true, preview = true },
      format = { preview = true },
      organizeImports = true,
    },
  },
  on_attach = function(client)
    -- basedpyright's hover has types and docs; ruff's would compete for `K`.
    client.server_capabilities.hoverProvider = false
  end,
}
