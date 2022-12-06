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

-- URL: https://github.com/simrat39/rust-tools.nvim/
local rt_status, rt = pcall(require, 'rust-tools')
if not rt_status then
  return
end

local ih_status, ih = pcall(require, 'inlay-hints')
if not ih_status then
  return
end

local keymap = vim.keymap

-- -- Enable inlay hints auto update and set them for all the buffers.
-- rt.inlay_hints.enable()
rt.setup({
  tools = {
    on_initialized = function()
      ih.set_all()
    end,
    inlay_hints = {
      -- automatically set inlay hints (type hints)
      auto = true,
      -- prefix for parameter hints
      -- default: "<- "
      parameter_hints_prefix = '« ',

      -- prefix for all the other hints (type, chaining)
      -- default: "=> "
      other_hints_prefix = '» ',
    },
  },
  server = {
    on_attach = function(client, bufnr)
      ih.on_attach(client, bufnr)
      -- Hover actions
      keymap.set('n', '<C-Space>', rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      keymap.set('n', '<leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
