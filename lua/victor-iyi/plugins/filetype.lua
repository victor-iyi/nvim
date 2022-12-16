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
-- Some servers have issues with backup files, see #649.

-- URL: https://github.com/victor-iyi/nvim/issues/3
local status, filetype = pcall(require, 'filetype')

if not status then
  return
end

filetype.setup({
  overrides = {
    -- Set the filetype of {key} to {value]
    extensions = {
      -- pn = 'potion',
    },
    -- Set filetype of {key} to {value}
    literal = {
      -- MyBackupFile = 'lua',
    },
    -- Set the filetype of any full filename matching the regex to {value}
    complex = {
      ['.flake8'] = 'dosini',
      ['[\\.]?aliases'] = 'sh',
      ['[\\.]?functions'] = 'sh',
      ['[\\.]?tmux.conf'] = 'tmux',
    },

    -- The same as the ones above except the keys map to functions.
    function_extensions = {
      -- ['pdf'] = function()
      --   vim.bo.filetype = 'pdf'
      --   -- Open in PDF viewer (Skim.app) automattically.
      --   vim.fn.jobstart(
      --     'open -a skim ' .. '"' .. vim.fn.expand('%') .. '"'
      --   )
      -- end,
    },
    function_literal = {
      -- Brewfile = function()
      --   vim.cmd('syntax off')
      -- end,
    },
    function_complex = {
      ['*.math_notes/%w+'] = function()
        vim.cmd('iabbrev $ $$')
      end,
    },

    -- Set the filetype of files with a {key} shebang to sh
    shebang = {
      -- dash = 'sh',
    },
  },
})
