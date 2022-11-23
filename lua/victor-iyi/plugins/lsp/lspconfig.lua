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

  -- Lsp finder find the symbol definition implement reference
  -- if there is no implement it will hide
  -- when you use action in finder like open vsplit then you can
  -- use <C-t> to jump back
  keymap.set('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>', opts)  -- show definition, references
  keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)   -- go to declaration
  keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', opts)   -- see definition and make edits in window
  keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)  -- go to implementation
  keymap.set({'n', 'v'}, '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)  -- see available code action
  keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts)  -- smart rename
  keymap.set('n', '<leader>d', '<cmd>Lspsaga show_line_diagnositics<CR>', opts)   -- show diagnostic for line
  keymap.set('n', '<leader>d', '<cmd>Lspsaga show_cursor_diagnostics<CR>', opts)  -- show diagnostic for cursor
  keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)  -- jump to previous diagnostic in buffer
  keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)  -- jump to next diagnostic in buffer
  keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)  -- show documentation
  keymap.set('n', '<leader>o', '<cmd>LSoutlineToggle<CR>', opts)  -- see outline on right hand side.

  -- typescript server.
  -- if client.name == 'tsserver' then
  --   keymap.set('n', '<leader>rf', ':TypescriptRenameFile<CR>')   -- rename file and update imports
  --   keymap.set('n', '<leader>oi', ':TypescriptOrganizeImports<CR>')  -- organize imports
  --   keymap.set('n', '<leader>ru', ':TypescriptRemoveUnused<CR>')     -- remove unused variables
  -- end

end


-- used to enable autocompletion.
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig['rust_analyzer'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure lua server (with special settings)
lspconfig['sumneko_lua'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {  -- custom settings for lua
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.stdpath('config') .. '/lua'] = true,
        },
      },
    },
  },
})

-- typescript.setup({
--   server = {
--     capabilities = capabilities,
--     on_attach = on_attach,
--   }
-- })
