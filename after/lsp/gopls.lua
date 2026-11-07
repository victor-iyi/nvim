-- Go.

---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
      semanticTokens = true,
      directoryFilters = { '-.git', '-node_modules', '-.venv' },
      -- Real bugs only. `shadow` is left off: it flags every idiomatic `err :=` in an inner scope.
      analyses = { unusedparams = true, unusedwrite = true, nilness = true },
      codelenses = { generate = true, test = true, tidy = true, upgrade_dependency = true },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
