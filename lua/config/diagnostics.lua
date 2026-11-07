-- How diagnostics look. Navigation maps are in `config/lsp.lua`.
local severity = vim.diagnostic.severity

local icons = {
  [severity.ERROR] = '󰅚 ',
  [severity.WARN] = '󰀪 ',
  [severity.INFO] = '󰋽 ',
  [severity.HINT] = '󰌶 ',
}

-- Inline text only for warnings and errors. Hints ("x is not accessed", inactive cfg
-- code, unused locals) still grey out the code and appear in `<leader>dl`, `]d` and
-- Trouble, but don't put a message on every other line.
local virtual_text = {
  spacing = 2,
  source = 'if_many',
  prefix = '●',
  severity = { min = severity.WARN },
}

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = virtual_text,
  virtual_lines = false,
  signs = {
    severity = { min = severity.INFO },
    text = icons,
    numhl = {
      [severity.ERROR] = 'DiagnosticSignError',
      [severity.WARN] = 'DiagnosticSignWarn',
    },
  },
  float = {
    source = 'if_many',
    header = '',
    prefix = function(diagnostic)
      local hl = 'DiagnosticSign' .. ({ 'Error', 'Warn', 'Info', 'Hint' })[diagnostic.severity]

      return icons[diagnostic.severity], hl
    end,
  },
})

-- Inline text is compact but truncates long messages (Rust's especially); virtual lines
-- show the full message, only for the cursor line so the buffer doesn't jump around.
vim.keymap.set('n', '<leader>dv', function()
  local inline = vim.diagnostic.config().virtual_text ~= false

  vim.diagnostic.config({
    virtual_text = not inline and virtual_text or false,
    virtual_lines = inline and { current_line = true } or false,
  })
end, { desc = 'Diagnostics: toggle inline text / virtual lines' })
