-- Floating terminal on <leader>ft, plus lazygit on <leader>gg when it is installed.
local toggleterm = require('toggleterm')

toggleterm.setup({
  size = 20,
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  persist_size = true,
  direction = 'float',
  float_opts = {
    border = 'curved',
    winblend = 0,
    width = function()
      return math.floor(vim.o.columns * 0.85)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.80)
    end,
  },
  highlights = {
    FloatBorder = { link = 'FloatBorder' },
    NormalFloat = { link = 'Normal' },
  },
})

-- Same modes as toggleterm's `open_mapping` (normal, insert, terminal), but calling the
-- Lua API: `open_mapping` runs `:ToggleTerm`, which uses the deprecated `vim.validate{}`.
vim.keymap.set({ 'n', 'i', 't' }, '<leader>ft', function()
  toggleterm.toggle(vim.v.count)
end, { desc = 'Floating terminal' })

local lazygit

vim.keymap.set('n', '<leader>gg', function()
  if vim.fn.executable('lazygit') == 0 then
    vim.notify('lazygit is not installed (brew install lazygit)', vim.log.levels.WARN)
    return
  end

  lazygit = lazygit
    or require('toggleterm.terminal').Terminal:new({
      cmd = 'lazygit',
      direction = 'float',
      hidden = true,
      float_opts = { border = 'curved' },
    })

  lazygit:toggle()
end, { desc = 'Lazygit' })
