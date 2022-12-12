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

-- Find more extensions here: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions
local extensions = {
  'coc-clangd', -- for C/C++/Ojbective-C, use clangd.
  'coc-clang-format-style-options', -- coc.nvim extension, helps you write `.clang-format` more easily.
  -- 'coc-cmake', -- for cmake code completion
  'coc-copilot', -- for GitHub Copilot completion.
  'coc-css', -- for `css`, `scss`, `less`.
  'coc-diagnostic', -- for All filetypes, use `diagnostic-languageserver`.
  'coc-dash-complete', -- Pres `-` to trigger buffer source completion.
  -- 'coc-dot-complete', -- Press `.` to trigger buffer source completion. (Not maintained anymore)
  'coc-docker', -- for 'dockerfile`.
  -- 'coc-emmet', -- provides emmet suggestions in completion list.
  'coc-explorer', -- File explorer extension.
  'coc-floaterm', -- for `vim-floaterm` integeration.
  'coc-fzf-preview', -- provides powerful `fzf` integration.
  'coc-gist', -- gist management.
  'coc-git', -- provides git integration.
  'coc-go', -- for `go`, use `gopls`.
  'coc-highlight', -- provides default document symbol highlighting and color support.
  'coc-html', -- for `html`, `handlebars` and `razor`.
  'coc-json', -- for `json`.
  'coc-just-complete', -- Press `_` to trigger buffer source compeletion.
  'coc-lists', -- provides some basic lists like fzf.vim
  'coc-lightbulb', -- Code action `:lightbulb` for coc.nvim
  'coc-markdownlint', -- for markdown linting.
  'coc-markdown-preview-enhanced', -- Markdown Preview Enhanced for coc.nvim
  'coc-pydocstring', -- for `python`, using doq (python docstring generator) extension.
  'coc-pyright', -- for `python`, Pyright extension.
  'coc-rust-analyzer', -- for `rust`, use rust-analyzer.
  'coc-sh', -- for `bash` using bash-language-server.
  'coc-snippets', -- provides snippets solution.
  'coc-sql', -- for `sql`.
  'coc-stylua', -- Stylua (lua formatter) extension
  'coc-sumneko-lua', -- Lua extension using sumneko lua-language-server
  'coc-svelte', -- for svelte.
  'coc-toml', -- for `toml` using taplo.
  'coc-tsserver', -- for `javascript` and `typescript`.
  'coc-vimlsp', -- for `viml`.
  'coc-yaml', -- for `yaml`.
  'coc-yank', -- provides yank highlights & history.
}

local ext_str = ''

for _, ext in ipairs(extensions) do
  ext_str = ext_str .. ' ' .. ext
end

return {
  extensions = extensions,
  ext_str = ext_str,
}
