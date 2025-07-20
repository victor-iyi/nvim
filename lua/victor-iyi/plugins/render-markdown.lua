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

-- render-markdown
-- URL: https://github.com/MeanderingProgrammer/render-markdown.nvim
local status, render = pcall(require, 'render-markdown')
if not status then
  return
end

render.setup({
  link = {
    -- Turn on / off inline link icon rendering.
    enabled = true,
    -- Additional modes to render links.
    render_modes = false,
    -- How to handle footnote links, start with a '^'.
    footnote = {
      -- Turn on / off footnote rendering.
      enabled = true,
      -- Replace value with superscript equivalent.
      superscript = true,
      -- Added before link content.
      prefix = '',
      -- Added after link content.
      suffix = '',
    },
    -- Inlined with 'image' elements.
    image = '󰥶 ',
    -- Inlined with 'email_autolink' elements.
    email = '󰀓 ',
    -- Fallback icon for 'inline_link' and 'uri_autolink' elements.
    hyperlink = '󰌹 ',
    -- Applies to the inlined icon as a fallback.
    highlight = 'RenderMarkdownLink',
    -- Applies to WikiLink elements.
    wiki = {
      icon = '󱗖 ',
      body = function()
        return nil
      end,
      highlight = 'RenderMarkdownWikiLink',
    },
    -- Define custom destination patterns so icons can quickly inform you of what a link
    -- contains. Applies to 'inline_link', 'uri_autolink', and wikilink nodes. When multiple
    -- patterns match a link the one with the longer pattern is used.
    -- The key is for healthcheck and to allow users to change its values, value type below.
    -- | pattern   | matched against the destination text                            |
    -- | icon      | gets inlined before the link text                               |
    -- | kind      | optional determines how pattern is checked                      |
    -- |           | pattern | @see :h lua-patterns, is the default if not set       |
    -- |           | suffix  | @see :h vim.endswith()                                |
    -- | priority  | optional used when multiple match, uses pattern length if empty |
    -- | highlight | optional highlight for 'icon', uses fallback highlight if empty |
    custom = {
      web = { pattern = '^http', icon = '󰖟 ' },
      discord = { pattern = 'discord%.com', icon = '󰙯 ' },
      github = { pattern = 'github%.com', icon = '󰊤 ' },
      gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
      google = { pattern = 'google%.com', icon = '󰊭 ' },
      neovim = { pattern = 'neovim%.io', icon = ' ' },
      reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
      stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
      wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
      youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
    },
  },

  bullet = {
    -- Useful context to have when evaluating values.
    -- | level | how deeply nested the list is, 1-indexed          |
    -- | index | how far down the item is at that level, 1-indexed |
    -- | value | text value of the marker node                     |

    -- Turn on / off list bullet rendering
    enabled = true,
    -- Additional modes to render list bullets
    render_modes = false,
    -- Replaces '-'|'+'|'*' of 'list_item'.
    -- If the item is a 'checkbox' a conceal is used to hide the bullet instead.
    -- Output is evaluated depending on the type.
    -- | function   | `value(context)`                                    |
    -- | string     | `value`                                             |
    -- | string[]   | `cycle(value, context.level)`                       |
    -- | string[][] | `clamp(cycle(value, context.level), context.index)` |
    icons = { '●', '○', '◆', '◇' },
    -- Replaces 'n.'|'n)' of 'list_item'.
    -- Output is evaluated using the same logic as 'icons'.
    ordered_icons = function(ctx)
      local value = vim.trim(ctx.value)
      local index = tonumber(value:sub(1, #value - 1))
      return ('%d.'):format(index > 1 and index or ctx.index)
    end,
    -- Padding to add to the left of bullet point.
    -- Output is evaluated depending on the type.
    -- | function | `value(context)` |
    -- | integer  | `value`          |
    left_pad = 0,
    -- Padding to add to the right of bullet point.
    -- Output is evaluated using the same logic as 'left_pad'.
    right_pad = 0,
    -- Highlight for the bullet icon.
    -- Output is evaluated using the same logic as 'icons'.
    highlight = 'RenderMarkdownBullet',
    -- Highlight for item associated with the bullet point.
    -- Output is evaluated using the same logic as 'icons'.
    scope_highlight = {},
  },
})
