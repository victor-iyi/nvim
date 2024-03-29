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

-- Setup colorscheme.
local colorscheme = 'nightfly'
local cmd = vim.cmd

local status, _ = pcall(cmd.colorscheme, colorscheme)
-- local status, _ pcall(cmd, 'colorscheme ' .. colorscheme)

if not status then
  vim.notify('colorscheme ' .. colorscheme .. ' not found')
  return
end

-- Use terminal background.
cmd('hi Normal ctermbg=none guibg=none')
