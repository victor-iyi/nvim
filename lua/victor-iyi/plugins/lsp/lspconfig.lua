-- Copyright 2022 Victor I. Afolabi
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local lspconfig_status, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status then
  return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_status then
  return
end


local keymap = vim.keymap

local on_attach = function(client, buffr)
  local opts = { noremap = true, silent = true, buffer = buffr }

  -- set keybinds
  keymap.set('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>', opts)
  keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', opts)
  keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
  keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts)
  keymap.set('n', '<leader>d', '<cmd>Lspsaga show_line_diagnositics<CR>', opts)
  keymap.set('n', '<leader>d', '<cmd>Lspsaga show_cursor_diagnostics<CR>', opts)
  keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
  keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_hump_next<CR>', opts)
  keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
  keymap.set('n', '<leader>o', '<cmd>LSoutlineToggle<CR>', opts)

  -- typescript server.
  -- if client.name == 'tsserver' then
  --   keymap.set('n', '<leader>rf', ':TypescriptRenameFile<CR>')
  -- end

end


-- used to enable autocompletion.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig['rust_analyzer'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- typescript.setup({
--   server = {
--     capabilities = capabilities,
--     on_attach = on_attach,
--   }
-- })
