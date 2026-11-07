-- Linters that aren't covered by a language server (ruff, eslint, clippy are LSP-side).
local lint = require('lint')

lint.linters_by_ft = {
  dockerfile = { 'hadolint' },
  markdown = { 'markdownlint-cli2' },
  go = { 'golangcilint' },
}

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

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('config.lint', { clear = true }),
  desc = 'Lint buffer',
  callback = function()
    local names = vim.tbl_filter(executable, lint.linters_by_ft[vim.bo.filetype] or {})

    if #names > 0 then
      lint.try_lint(names)
    end
  end,
})
