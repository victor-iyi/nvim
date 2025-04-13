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

-- Install packer if it doesn't exist.
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save this file.
local api = vim.api
local user_config = api.nvim_create_augroup('packer_user_config', { clear = true })
api.nvim_create_autocmd('BufWritePost', {
  group = user_config,
  pattern = 'packer.lua',
  command = [[source <afile> | PackerSync]],
  desc = 'Autocommand that reloads neovim whenever you save this file.',
})

-- Plugins.
local status, packer = pcall(require, 'packer')
if not status then
  return
end

return packer.startup(function(use)
  use('wbthomason/packer.nvim')

  -- lua functions that many plugins use
  use('nvim-lua/plenary.nvim')

  -- ==================================================
  -- Editor/GUI enhancements.
  -- ==================================================
  -- Colorschemes
  -- use 'ayu-theme/ayu-vim'
  use('bluz71/vim-nightfly-guicolors')

  -- Add file type icons to the file tree.
  use('kyazdani42/nvim-web-devicons')

  -- Terminal
  use('akinsho/toggleterm.nvim')

  -- NERDTree
  use('preservim/nerdtree')
  use({
    'tiagofumo/vim-nerdtree-syntax-highlight',
    requires = 'preservim/nerdtree',
  })

  -- Undo tree.
  use('mbbill/undotree')

  -- statusline
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  })

  -- ==================================================
  -- Semantic language support
  -- ==================================================
  -- Incremental parsing system for programming tools.
  use({
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({
        with_sync = true,
      })
      ts_update()
    end,
  })
  use({ 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' })
  use({
    'p00f/nvim-ts-rainbow',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  })

  -- autoclose parens, brackets, quotes, etc.
  use('windwp/nvim-autopairs')

  -- Automatically manages python virtual env.
  use('sansyrox/vim-python-virtualenv')

  -- GitHub copilot.
  use('github/copilot.vim')

  -- ==================================================
  -- General purpose plugins.
  -- ==================================================
  -- Git integration.
  use('tpope/vim-fugitive')

  -- delete/change/add parentheses/quotes/tags with ease.
  use({
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end,
  })

  -- comment stuff out with gc, gcc
  use('numToStr/Comment.nvim')

  -- edotorconfig for vim.
  use('editorconfig/editorconfig-vim')

  -- TMUX & split window navigation.
  use('christoomey/vim-tmux-navigator')

  -- maximize and restores current window.
  use('szw/vim-maximizer')

  -- Make the yanked region apparent.
  use('machakann/vim-highlightedyank')

  -- Better % - highlight and navigate matching pattern.
  use('andymass/vim-matchup')

  -- Multiple cursors.
  use('mg979/vim-visual-multi')

  -- ==================================================
  -- Files and folders
  -- ==================================================
  -- file explorer
  use({
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- file type icons
    },
  })

  -- Fuzzy finding
  use({
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  })
  use({
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  })

  -- File assocoiation
  use('nathom/filetype.nvim')

  -- Changes working directory to project root.
  use('airblade/vim-rooter')

  -- git integration
  use('lewis6991/gitsigns.nvim') -- show line modification on left hand side.

  -- ==================================================
  -- Language server protocol
  -- ==================================================
  -- Setup & plugin development.
  use({
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup()
    end,
  })

  -- Conquer of completion for neovim.
  use({
    'neoclide/coc.nvim',
    branch = 'release',
    -- run = ':CocInstall coc-rust-analyzer coc-pyright coc-diagnostic'
  })

  -- Autocompletion.
  -- Managing & configurations for Nvim LSP.
  use({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  })

  -- Auto completion.
  use({
    -- nvim-cmp sources.
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    -- 'hrsh7th/cmp-copilot',
    'petertriho/cmp-git',
    'Saecki/crates.nvim',
  })

  -- Snippets.
  use('L3MON4D3/LuaSnip')
  use('saadparwaiz1/cmp_luasnip')
  use('rafamadriz/friendly-snippets')

  -- Configuring lsp servers
  use({
    'glepnir/lspsaga.nvim',
    branch = 'main',
    requires = {
      { 'nvim-tree/nvim-web-devicons' },
      -- Please make sure you install markdown and markdown_inline parser
      { 'nvim-treesitter/nvim-treesitter' },
    },
  })
  use('onsails/lspkind.nvim')

  -- Type hints.
  -- use 'simrat39/inlay-hints.nvim'
  -- use 'simrat39/rust-tools.nvim'

  -- formatting and linting
  -- use 'jose-elias-alvarez/null-ls.nvim'   -- configure formatters and linters
  -- use 'jayp0521/mason-null-ls.nvim' -- bridges gap b/w mason & null-ls
  use('mhartington/formatter.nvim')

  -- Improve Rust experience.
  use('rust-lang/rust.vim')

  -- Markdown Preview.
  use({
    'iamcco/markdown-preview.nvim',
    run = 'cd app && npm install',
    setup = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
