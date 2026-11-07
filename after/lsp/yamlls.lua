-- YAML, validated against SchemaStore (GitHub Actions, docker-compose, k8s, …).

---@type vim.lsp.Config
return {
  before_init = function(_, config)
    local schemas = { yaml = { schemas = require('schemastore').yaml.schemas() } }
    config.settings = vim.tbl_deep_extend('force', config.settings or {}, schemas)
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = { enable = true },
      validate = true,
      -- Disabled so SchemaStore.nvim is the single schema source.
      schemaStore = { enable = false, url = '' },
    },
  },
}
