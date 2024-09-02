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

-- URL: https://github.com/mhartington/formatter.nvim
local fmt_status, fmt = pcall(require, 'formatter')
if not fmt_status then
  return
end

local util_status, util = pcall(require, 'formatter.util')
if not util_status then
  return
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands.
fmt.setup({
  -- Enable or disable logging.
  logging = false,
  -- Set the log level.
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype go here...
    -- and wil be executed in order.
    lua = {
      -- 'formatter.filetypes.lua' defines default configurations for the
      -- "lua" filetype.
      -- require("formatter.filetypes.lua").stylua,
      function()
        return {
          exe = 'stylua',
          args = {
            '--search-parent-directories',
            '--stdin-filepath',
            util.escape_path(util.get_current_buffer_file_path()),
            '--quote-style=AutoPreferSingle',
            '--indent-width=2',
            '--indent-type=Spaces',
            '--',
            '-',
          },
          stdin = true,
        }
      end,
    },
    rust = {
      -- require('formatter.filetypes.any').remove_trailing_whitespace,
      -- require('formatter.filetypes.rust').rustfmt,
      function()
        return {
          exe = 'rustfmt',
          args = {
            '--edition 2021',
            '--config tab_spaces=2',
          },
          stdin = true,
        }
      end,
    },
    python = {
      require('formatter.filetypes.python').ruff,
      -- require('formatter.filetypes.python').black,
    },
  },
})

-- Format after save.
local api = vim.api

local fmt_group = api.nvim_create_augroup('FormatAutogroup', { clear = true })
api.nvim_create_autocmd('BufWritePost', {
  group = fmt_group,
  pattern = '*',
  command = 'FormatWrite',
  desc = 'Format after save',
})

-- vim.cmd [[
-- autogroup FormatAutogroup
--   autocmd!
--   autocmd BufWritePost * FormatWrite
-- autogroup END
-- ]]
