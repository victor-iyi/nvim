-- GitHub Copilot. Its insert-mode keys (<C-l>, <C-k>, <C-]>, <C-[>) are in `config/keymaps.lua`.

-- <Tab> belongs to nvim-cmp and snippets.
vim.g.copilot_no_tab_map = true

vim.g.copilot_filetypes = {
  ['*'] = true,
  gitcommit = true,
  markdown = true,
  yaml = true,
  TelescopePrompt = false,
  ['dap-repl'] = false,
  dashboard = false,
}
