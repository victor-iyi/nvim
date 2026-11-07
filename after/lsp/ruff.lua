-- Python lint, format and import sorting.

---@type vim.lsp.Config
return {
  init_options = {
    settings = {
      -- pyproject.toml / ruff.toml decide the rules, line length and target version.
      -- (ruff's default, "editorFirst", lets editor settings override the project.)
      configurationPreference = 'filesystemFirst',
      lint = { enable = true },
      organizeImports = true,
    },
  },
  on_attach = function(client)
    -- basedpyright's hover has types and docs; ruff's would compete for `K`.
    client.server_capabilities.hoverProvider = false
  end,
}
