-- Floating terminal on <leader>ft, plus lazygit on <leader>gg when it is installed.
require('toggleterm').setup({
  size = 20,
  open_mapping = '<leader>ft',
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
