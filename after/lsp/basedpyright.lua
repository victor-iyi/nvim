-- Python types and navigation. Ruff handles linting, formatting and import sorting.

-- Point the server at the project's interpreter so third-party imports resolve.
local function project_python(root)
  if vim.env.VIRTUAL_ENV then
    return vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  for _, dir in ipairs({ '.venv', 'venv' }) do
    local python = vim.fs.joinpath(root or vim.fn.getcwd(), dir, 'bin', 'python')

    if vim.uv.fs_stat(python) then
      return python
    end
  end
end

---@type vim.lsp.Config
return {
  before_init = function(_, config)
    local python = project_python(config.root_dir)

    if python then
      config.settings = vim.tbl_deep_extend('force', config.settings or {}, { python = { pythonPath = python } })
    end
  end,
  -- Defaults for projects without [tool.basedpyright] / [tool.pyright] / pyrightconfig.json;
  -- when one exists, its values override everything under `analysis` here.
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        -- "recommended" (the default) floods ordinary code with warnings.
        typeCheckingMode = 'standard',
        diagnosticMode = 'openFilesOnly',
        -- Ruff reports these (F401, F841, F821); showing both doubles every finding.
        diagnosticSeverityOverrides = {
          reportUnusedImport = 'none',
          reportUnusedVariable = 'none',
          reportUndefinedVariable = 'none',
        },
        autoImportCompletions = true,
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          functionReturnTypes = true,
          genericTypes = false,
        },
      },
    },
  },
}
