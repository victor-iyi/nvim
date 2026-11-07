-- Lua. lazydev.nvim feeds the Neovim runtime and plugin types on demand.

---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      hint = { enable = true, arrayIndex = 'Disable', setType = true },
      completion = { callSnippet = 'Replace' },
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      format = { enable = false }, -- stylua formats Lua.
    },
  },
}
