-- Plugins, managed by the built-in `vim.pack`.
--
-- Update with `:lua vim.pack.update()` (review, then `:write` to apply). Exact revisions
-- are pinned in `nvim-pack-lock.json`, which is committed alongside this file.

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Build steps that must run after a plugin is installed or updated, keyed by plugin name.
local builds = {
  ['telescope-fzf-native.nvim'] = function(path)
    vim.system({ 'make' }, { cwd = path }):wait()
  end,

  ['LuaSnip'] = function(path)
    vim.system({ 'make', 'install_jsregexp' }, { cwd = path })
  end,

  ['markdown-preview.nvim'] = function(path)
    vim.system({ 'sh', './install.sh' }, { cwd = vim.fs.joinpath(path, 'app') })
  end,

  ['nvim-treesitter'] = function(_, kind)
    if kind == 'update' then
      vim.schedule(function()
        pcall(vim.cmd.TSUpdate)
      end)
    end
  end,
}

-- Registered before the first `vim.pack.add`, which is what installs from the lockfile
-- on a fresh machine.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('config.pack', { clear = true }),
  desc = 'Run plugin build steps',
  callback = function(ev)
    local data = ev.data
    local build = builds[data.spec.name]

    if not build or (data.kind ~= 'install' and data.kind ~= 'update') then
      return
    end

    build(data.path, data.kind)
  end,
})

vim.pack.add({
  -- Libraries.
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-tree/nvim-web-devicons'),

  -- UI.
  gh('bluz71/vim-nightfly-colors'),
  gh('nvim-lualine/lualine.nvim'),
  gh('sitiom/nvim-numbertoggle'),
  gh('folke/trouble.nvim'),

  -- Files & search.
  gh('nvim-tree/nvim-tree.lua'),
  gh('preservim/nerdtree'),
  gh('tiagofumo/vim-nerdtree-syntax-highlight'),
  gh('nvim-telescope/telescope.nvim'),
  gh('nvim-telescope/telescope-fzf-native.nvim'),
  gh('airblade/vim-rooter'),
  gh('mbbill/undotree'),

  -- Editing.
  gh('kylechui/nvim-surround'),
  gh('numToStr/Comment.nvim'),
  gh('windwp/nvim-autopairs'),
  gh('andymass/vim-matchup'),
  gh('mg979/vim-visual-multi'),
  gh('szw/vim-maximizer'),

  -- tmux & terminal.
  gh('christoomey/vim-tmux-navigator'),
  gh('akinsho/toggleterm.nvim'),

  -- Treesitter.
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
  gh('windwp/nvim-ts-autotag'),
  gh('HiPhish/rainbow-delimiters.nvim'),

  -- Git.
  gh('tpope/vim-fugitive'),
  gh('lewis6991/gitsigns.nvim'),
  gh('f-person/git-blame.nvim'),

  -- LSP.
  gh('neovim/nvim-lspconfig'),
  gh('mason-org/mason.nvim'),
  gh('mason-org/mason-lspconfig.nvim'),
  gh('nvimdev/lspsaga.nvim'),
  gh('folke/lazydev.nvim'),
  gh('b0o/SchemaStore.nvim'),

  -- Completion & snippets.
  gh('hrsh7th/nvim-cmp'),
  gh('hrsh7th/cmp-nvim-lsp'),
  gh('hrsh7th/cmp-buffer'),
  gh('hrsh7th/cmp-path'),
  gh('hrsh7th/cmp-cmdline'),
  gh('petertriho/cmp-git'),
  gh('L3MON4D3/LuaSnip'),
  gh('saadparwaiz1/cmp_luasnip'),
  gh('rafamadriz/friendly-snippets'),
  gh('onsails/lspkind.nvim'),
  gh('github/copilot.vim'),

  -- Formatting & linting.
  gh('mhartington/formatter.nvim'),
  gh('mfussenegger/nvim-lint'),
  gh('rshkarin/mason-nvim-lint'),

  -- Debugging.
  gh('mfussenegger/nvim-dap'),
  gh('igorlfs/nvim-dap-view'),
  gh('mfussenegger/nvim-dap-python'),

  -- Languages.
  gh('mrcjkb/rustaceanvim'),
  gh('rust-lang/rust.vim'),
  gh('saecki/crates.nvim'),
  gh('iamcco/markdown-preview.nvim'),
  gh('MeanderingProgrammer/render-markdown.nvim'),
}, { confirm = false })
