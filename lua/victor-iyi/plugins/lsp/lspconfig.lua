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

-- Language server.
local lspconfig_status, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status then
  return
end

-- Completion.
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_status then
  return
end

-- Type/parameter hints.
local ih_status, ih = pcall(require, 'inlay-hints')
if not ih_status then
  return
end

-- vim keymap
local keymap = vim.keymap

local on_attach = function(client, buffr)
  -- inlay hints.
  ih.on_attach(client, buffr)

  local opts = { noremap = true, silent = true, buffer = buffr }

  -- set keybinds

  -- lsp finder find the symbol definition implement reference
  -- if there is no implement it will hide
  -- when you use action in finder like open vsplit then you can
  -- use <c-t> to jump back
  keymap.set('n', 'gf', '<cmd>lspsaga lsp_finder<cr>', opts)

  -- code action
  keymap.set({'n', 'v'}, '<leader>ca', '<cmd>lspsaga code_action<cr>', opts)

  -- rename
  keymap.set('n', '<leader>rn', '<cmd>lspsaga rename<cr>', opts)  -- smart rename

  -- peek definition.
  -- you can edit the definition file in this floatwindow
  -- also support open/vsplit/etc operation check definition_action_keys
  -- support tagstack c-t jump back.
  keymap.set('n', 'gd', '<cmd>lspsaga peek_definition<cr>', opts)

  -- go to declaration
  keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

  -- go to implementation
  keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)  -- go to implementation

  -- show line diagnostics.
  keymap.set('n', '<leader>dl', '<cmd>lspsaga show_line_diagnositics<cr>', opts)

  -- show cursor diagnostic
  keymap.set('n', '<leader>dc', '<cmd>lspsaga show_cursor_diagnostics<cr>', opts)

  -- diagnostic jump can use `<c-o>` to jump back.
  keymap.set('n', '[d', '<cmd>lspsaga diagnostic_jump_prev<cr>', opts)  -- jump to previous diagnostic in buffer
  keymap.set('n', ']d', '<cmd>lspsaga diagnostic_jump_next<cr>', opts)  -- jump to next diagnostic in buffer

  -- only jump to error.
  keymap.set(
    'n', '[e', function()
      require('lspsaga.diagnostic').goto_prev({ serverity = vim.diagnostic.severity.error })
    end, opts)
  keymap.set(
    'n', ']e', function()
      require('lspsaga.diagnostic').goto_next({ serverity = vim.diagnostic.severity.error })
    end, opts)

  -- outline: see outline at the right hand side.
  keymap.set('n', '<leader>o', '<cmd>lsoutlinetoggle<cr>', opts)

  -- hover doc: show documentation.
  keymap.set('n', 'k', '<cmd>lspsaga hover_doc<cr>', opts)

  -- float terminal
  keymap.set('n', '<a-d>', '<cmd>lspsaga open_floaterm<cr>', opts)
  -- if you wan tpass some cli command into terminal you can do like this
  -- open lazygit in lspsaga float terminal
  keymap.set('n', '<a-d>', '<cmd>lspsaga open_floaterm lazygit<cr>', opts)
  -- close floaterm
  keymap.set('t', '<a-d>', [[<c-\><c-n><cmd>lspsaga close_floaterm<cr>]], opts)

end

-- used to enable autocompletion.
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Language servers to enable.
local servers = {
  'rust_analyzer',  -- Rust
  'sumneko_lua',    -- Lua
  'pyright',        -- Python
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- configure lua server (with special settings)
lspconfig['sumneko_lua'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {  -- custom settings for lua
    lua = {
      hint = {
        enable = true,
      },
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand('$vimruntime/lua')] = true,
          [vim.fn.stdpath('config') .. '/lua'] = true,
        },
      },
    },
  },
})

