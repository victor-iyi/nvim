-- Rust-only actions from rustaceanvim, under <leader>r (next to <leader>rn rename).
local function map(lhs, args, desc)
  vim.keymap.set('n', lhs, function()
    vim.cmd.RustLsp(args)
  end, { buffer = true, desc = 'Rust: ' .. desc })
end

map('<leader>rr', 'runnables', 'runnables')
map('<leader>rd', 'debuggables', 'debuggables')
map('<leader>rt', 'testables', 'testables')
map('<leader>rm', 'expandMacro', 'expand macro')
map('<leader>re', 'explainError', 'explain error')
map('<leader>rc', 'openCargo', 'open Cargo.toml')
