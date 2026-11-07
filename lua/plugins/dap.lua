-- Debugging (Python via debugpy, Rust/C via codelldb through rustaceanvim). Set up on the
-- first debug key press; F-keys follow VS Code.
local configured = false

local function dap()
  if configured then
    return require('dap')
  end

  configured = true

  local d = require('dap')

  -- Opens with a debug session and closes when it ends.
  require('dap-view').setup({ auto_toggle = true })

  -- Mason's debugpy runs the adapter; the debuggee uses the project's venv interpreter.
  local debugpy = vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', 'debugpy', 'venv', 'bin', 'python')
  require('dap-python').setup(vim.uv.fs_stat(debugpy) and debugpy or 'python3')

  vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
  vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'Visual' })

  return d
end

local function call(fn)
  return function()
    dap()[fn]()
  end
end

local map = vim.keymap.set

map('n', '<F5>', call('continue'), { desc = 'Debug: start / continue' })
map('n', '<S-F5>', call('terminate'), { desc = 'Debug: stop' })
map('n', '<F9>', call('toggle_breakpoint'), { desc = 'Debug: toggle breakpoint' })
map('n', '<F10>', call('step_over'), { desc = 'Debug: step over' })
map('n', '<F11>', call('step_into'), { desc = 'Debug: step into' })
map('n', '<S-F11>', call('step_out'), { desc = 'Debug: step out' })
map('n', '<leader>db', call('toggle_breakpoint'), { desc = 'Debug: toggle breakpoint' })

map('n', '<leader>dB', function()
  dap().set_breakpoint(vim.fn.input('Condition: '))
end, { desc = 'Debug: conditional breakpoint' })

map('n', '<leader>du', function()
  dap()
  require('dap-view').toggle()
end, { desc = 'Debug: toggle UI' })
