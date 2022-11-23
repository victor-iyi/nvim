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

-- nvim-cmp
-- URL: https://github.com/hrsh7th/nvim-cmp
local status, cmp = pcall(require, 'cmp')
if not status then
  return
end


local luasnip_status, luasnip = pcall(require, 'luasnip')
if not luasnip_status then
  return
end

-- load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

vim.opt.completeopt = 'menu,menuone,noselect'

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),  -- previous suggestion
    ['<C-j>'] = cmp.mapping.select_next_item(),  -- next suggestion
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),       -- show complete suggestions
    ['<C-e>'] = cmp.mapping.abort(),              -- close completion window
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },   -- Snippets
    { name = 'buffer' },    -- text within current buffer
    { name = 'path' },      -- file system paths
  }),
})
