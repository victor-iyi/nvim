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

local ih_status, ih = pcall(require, 'inlay-hints')
if not ih_status then
  return
end

ih.setup({
  -- Only show inlay hints for the current line.
  only_current_line = false,
  eol = {
    -- whether to align to the extreme right or not.
    right_align = false,

    parameter = {
      separator = ', ',
      format = function(hints)
        return string.format(' « (%s)', hints)
      end,
    },

    type = {
      separator = ', ',
      format = function(hints)
        return string.format(' » (%s)', hints)
      end,
    },

  },
})

