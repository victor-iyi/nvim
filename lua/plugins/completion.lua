-- Completion: nvim-cmp with LSP (crates.io via crates.nvim's in-process server), paths, git; LuaSnip expands LSP snippets.
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

require('cmp_git').setup()

require('crates').setup({
  lsp = { enabled = true, actions = true, hover = true, completion = true },
  popup = { border = 'rounded' },
})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  -- Mappings unchanged from the previous config.
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'lazydev', group_index = 0 }, -- Neovim API, only in Lua files.
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'git' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
    }),
  },
  experimental = { ghost_text = false }, -- Copilot owns inline ghost text.
})

-- Insert `(` after confirming a function or method.
cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
