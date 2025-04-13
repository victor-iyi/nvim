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

-- URL: https://github.com/williamboman/mason.nvim
local mason_status, mason = pcall(require, 'mason')
if not mason_status then
  return
  -- else
  -- mason.setup({
  --   ui = {
  --     icons = {
  --       package_installed = "✓",
  --       package_pending = "➜",
  --       package_uninstalled = "✗"
  --     }
  --   }
  -- })
end

-- default configuration.
mason.setup()

-- URL: https://github.com/williamboman/mason-lspconfig.nvim
local mason_lsp_status, mason_lsp = pcall(require, 'mason-lspconfig')
if not mason_lsp_status then
  return
end

-- Register LSP servers.
mason_lsp.setup({
  -- A list of servers to automatically install if they're not already installed.
  -- Example: { "rust_analyzer@nightly", "sumneko_lua" }
  -- This setting has no relation with the `automatic_installation` setting.
  ensure_installed = {
    'rust_analyzer', -- Rust
    'ruff', -- Python
    'lua_ls', -- Lua
    'bashls', -- Bash
    'clangd', -- C/C++
    'dockerls', -- Docker
    'diagnosticls', -- Diagnostic (general purpose server)
  },

  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  --
  -- automatic_installation = false,
})
