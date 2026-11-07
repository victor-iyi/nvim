-- JSON, validated against SchemaStore (package.json, tsconfig, …).

---@type vim.lsp.Config
return {
  before_init = function(_, config)
    local schemas = { json = { schemas = require('schemastore').json.schemas() } }
    config.settings = vim.tbl_deep_extend('force', config.settings or {}, schemas)
  end,
  settings = {
    json = { validate = { enable = true } },
  },
}
