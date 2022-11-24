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
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


-- Autocommand that reloads neovim whenever you save this file.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

-- Plugins.
local status, packer = pcall(require, 'packer')
if not status then
  return
end

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- lua functions that many plugins use
  use 'nvim-lua/plenary.nvim'

  -- ==================================================
  -- Editor/GUI enhancements.
  -- ==================================================
  -- Colorschemes
  -- use 'ayu-theme/ayu-vim'
  use 'bluz71/vim-nightfly-guicolors'

  -- Add file type icons to the file tree.
  use 'kyazdani42/nvim-web-devicons'

  -- NERDTree
  use 'preservim/nerdtree'

  -- Undo tree.
  use 'mbbill/undotree'

  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- ==================================================
  -- Semantic language support
  -- ==================================================
  -- Incremental parsing system for programming tools.
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({
        with_sync = true
      })
      ts_update()
    end,
  }
  use { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' }
  use {
    'p00f/nvim-ts-rainbow',
    requires = { 'nvim-treesitter/nvim-treesitter' }
  }

  -- autoclose parens, brackets, quotes, etc.
  use 'windwp/nvim-autopairs'

  -- Automatically manages python virtual env.
  use 'sansyrox/vim-python-virtualenv'

  -- GitHub copilot.
  use 'github/copilot.vim'

  -- ==================================================
  -- General purpose plugins.
  -- ==================================================
  -- Git integration.
  use 'tpope/vim-fugitive'

  -- delete/change/add parentheses/quotes/tags with ease.
  use 'tpope/vim-surround'

  -- comment stuff out with gc, gcc
  use 'numToStr/Comment.nvim'

  -- edotorconfig for vim.
  use 'editorconfig/editorconfig-vim'

  -- TMUX & split window navigation.
  use 'christoomey/vim-tmux-navigator'

  -- maximize and restores current window.
  use 'szw/vim-maximizer'

  -- Make the yanked region apparent.
  use 'machakann/vim-highlightedyank'

  -- Better % - highlight and navigate matching pattern.
  use'andymass/vim-matchup'

  -- ==================================================
  -- Files and folders
  -- ==================================================
  -- file explorer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',  -- file type icons
    }
  }

  -- Fuzzy finding
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
  }

  -- Changes working directory to project root.
  use 'airblade/vim-rooter'

  -- git integration
  use 'lewis6991/gitsigns.nvim'  -- show line modification on left hand side.

  -- ==================================================
  -- Language server protocol
  -- ==================================================
  -- Conquer of completion for neovim.
  use { 'neoclide/coc.nvim', branch = 'release' }

  -- Autocompletion.
  -- Managing & configurations for Nvim LSP.
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  }

  -- Auto completion.
  use {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
  }

  -- Snippets.
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets'

  -- Configuring lsp servers
  use { 'glepnir/lspsaga.nvim', branch = 'main'}
  use 'onsails/lspkind.nvim'

  -- formatting and linting
  -- use 'jose-elias-alvarez/null-ls.nvim'   -- configure formatters and linters
  -- use 'jayp0521/mason-null-ls.nvim' -- bridges gap b/w mason & null-ls

  -- Improve Rust experience.
  -- use 'simrat39/rust-tools.nvim'


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
