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

-- Package manager.
require('victor-iyi.packer')

-- Core setup
require('victor-iyi.core.set')
require('victor-iyi.core.keymaps')
require('victor-iyi.core.colorscheme')

-- Plugins
require('victor-iyi.plugins.comment')
require('victor-iyi.plugins.devicons')
require('victor-iyi.plugins.filetype')
require('victor-iyi.plugins.formatter')
require('victor-iyi.plugins.gitsigns')
require('victor-iyi.plugins.lualine')
require('victor-iyi.plugins.nvim-tree')
require('victor-iyi.plugins.telescope')
require('victor-iyi.plugins.toggleterm')
require('victor-iyi.plugins.treesitter')

-- Language server.
-- require('victor-iyi.plugins.lsp.coc')  -- BUG: keymaps and lsp
-- require('victor-iyi.plugins.lsp.hints')  -- UNUSED: inlay hints.
require('victor-iyi.plugins.lsp.lspconfig')
require('victor-iyi.plugins.lsp.lspsaga')
require('victor-iyi.plugins.lsp.mason')
-- require('vicotr-iyi.plugins.lsp.null-ls') -- BUG: not working properly
require('victor-iyi.plugins.lsp.nvim-cmp')
-- require('victor-iyi.plugins.lsp.rust-tools')  -- UNUSED: inlay hints (for Rust)
