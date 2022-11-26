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

-- nvim-web-devicons
-- URL:https://github.com/nvim-tree/nvim-web-devicons
local status, devicons = pcall(require, 'nvim-web-devicons')
if not status then
  return
end

devicons.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
--  override = {
--   zsh = {
--     icon = "",
--     color = "#428850",
--     cterm_color = "65",
--     name = "Zsh"
--   }
--  };

 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;

 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
--  default = true;
}