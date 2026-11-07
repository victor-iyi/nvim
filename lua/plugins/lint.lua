-- Linters that aren't covered by a language server (ruff, eslint, clippy are LSP-side).
--
-- One rule for every linter: a project's own config always wins. Without one, a relaxed
-- base config from `lint/` keeps only the findings worth acting on, and linters that
-- would just repeat the language server run only when the project opts in.
local lint = require('lint')

local base_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lint')

---@class LinterPolicy
---@field project string[] Config files that mean "this project decides".
---@field base? string Base config (in `lint/`) for projects without one.
---@field opt_in? boolean Run only when the project has a config.

---@type table<string, LinterPolicy>
local policies = {
  ['markdownlint-cli2'] = {
    project = {
      '.markdownlint-cli2.jsonc',
      '.markdownlint-cli2.yaml',
      '.markdownlint-cli2.cjs',
      '.markdownlint-cli2.mjs',
      '.markdownlint.jsonc',
      '.markdownlint.json',
      '.markdownlint.yaml',
      '.markdownlint.yml',
      '.markdownlint.cjs',
      '.markdownlint.mjs',
    },
    base = '.markdownlint.yaml',
  },

  hadolint = {
    project = { '.hadolint.yaml', '.hadolint.yml' },
    base = 'hadolint.yaml',
  },

  -- Without a project config golangci-lint re-reports what gopls + staticcheck show.
  golangcilint = {
    project = { '.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json' },
    opt_in = true,
  },
}

lint.linters_by_ft = {
  dockerfile = { 'hadolint' },
  markdown = { 'markdownlint-cli2' },
  go = { 'golangcilint' },
}

-- The plugin's own args (format flags, stdin marker), captured before we prepend ours.
local default_args = {}

for name in pairs(policies) do
  default_args[name] = vim.deepcopy(lint.linters[name].args or {})
end

-- Mason installs the linters above.
require('mason-nvim-lint').setup({
  automatic_installation = #vim.api.nvim_list_uis() > 0,
  quiet_mode = true,
})

local function executable(name)
  local linter = lint.linters[name]
  local cmd = type(linter) == 'function' and linter().cmd or (linter and linter.cmd)

  if type(cmd) == 'function' then
    cmd = cmd()
  end

  return cmd and vim.fn.executable(cmd) == 1
end

-- Sets this run's `--config` (the project's, else the base) and returns false when the
-- linter should be skipped. Both linters take exactly one config, so it's explicit.
local function apply_policy(name, dir)
  local policy = policies[name]

  if not policy then
    return true
  end

  local config = vim.fs.find(policy.project, { path = dir, upward = true, type = 'file', limit = 1 })[1]

  if policy.opt_in and not config then
    return false
  end

  local chosen = config or (policy.base and vim.fs.joinpath(base_dir, policy.base))
  local extra = (chosen and not policy.opt_in) and { '--config', chosen } or {}
  lint.linters[name].args = vim.list_extend(extra, vim.deepcopy(default_args[name]))

  return true
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('config.lint', { clear = true }),
  desc = 'Lint buffer',
  callback = function(ev)
    local file = vim.api.nvim_buf_get_name(ev.buf)

    if file == '' or vim.bo[ev.buf].buftype ~= '' then
      return
    end

    -- From the file's folder, so configs in sub-folders are found (not just the repo root).
    local dir = vim.fs.dirname(file)
    local names = vim.tbl_filter(function(name)
      return executable(name) and apply_policy(name, dir)
    end, lint.linters_by_ft[vim.bo[ev.buf].filetype] or {})

    if #names > 0 then
      lint.try_lint(names, { cwd = dir })
    end
  end,
})
