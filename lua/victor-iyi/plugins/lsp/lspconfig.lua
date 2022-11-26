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

-- vim keymap
local keymap = vim.keymap


local on_attach = function(client, buffr)
  local opts = { noremap = true, silent = true, buffer = buffr }

  -- set keybinds

  -- Lsp finder find the symbol definition implement reference
  -- if there is no implement it will hide
  -- when you use action in finder like open vsplit then you can
  -- use <C-t> to jump back
  keymap.set('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>', opts)

  -- Code action
  keymap.set({'n', 'v'}, '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)

  -- Rename
  keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts)  -- smart rename

  -- Peek definition.
  -- You can edit the definition file in this floatwindow
  -- also support open/vsplit/etc operation check definition_action_keys
  -- support tagstack C-t jump back.
  keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', opts)

  -- Go to declaration
  keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)

  -- Go to implementation
  keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)  -- go to implementation

  -- Show line diagnostics.
  keymap.set('n', '<leader>dl', '<cmd>Lspsaga show_line_diagnositics<CR>', opts)

  -- Show cursor diagnostic
  keymap.set('n', '<leader>dc', '<cmd>Lspsaga show_cursor_diagnostics<CR>', opts)

  -- Diagnostic jump can use `<C-o>` to jump back.
  keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)  -- jump to previous diagnostic in buffer
  keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)  -- jump to next diagnostic in buffer

  -- Only jump to error.
  keymap.set(
    'n', '[E', function()
      require('lspsaga.diagnostic').goto_prev({ serverity = vim.diagnostic.severity.ERROR })
    end, opts)
  keymap.set(
    'n', ']E', function()
      require('lspsaga.diagnostic').goto_next({ serverity = vim.diagnostic.severity.ERROR })
    end, opts)

  -- Outline: see outline at the right hand side.
  keymap.set('n', '<leader>o', '<cmd>LSoutlineToggle<CR>', opts)

  -- Hover doc: show documentation.
  keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)

  -- Float terminal
  keymap.set('n', '<A-d>', '<cmd>Lspsaga open_floaterm<CR>', opts)
  -- if you wan tpass some cli command into terminal you can do like this
  -- open lazygit in lspsaga float terminal
  keymap.set('n', '<A-d>', '<cmd>Lspsaga open_floaterm lazygit<CR>', opts)
  -- close floaterm
  keymap.set('t', '<A-d>', [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], opts)

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

-- configure pyright
lspconfig['pyright'].setup({
  capabilities = capabilities,
})

-- typescript.setup({
--   server = {
--     capabilities = capabilities,
--     on_attach = on_attach,
--   }
-- })
