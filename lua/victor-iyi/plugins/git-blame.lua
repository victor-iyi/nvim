-- Copyright 2025 Victor I. Afolabi
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

-- URL: https://github.com/f-person/git-blame.nvim
local status, gitblame = pcall(require, 'gitblame')

if not status then
  return
end

-- configure/ enable gitblame.
gitblame.setup({
  enable = true,
})
