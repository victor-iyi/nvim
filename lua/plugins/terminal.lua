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

-- Your own lazygit config, plus `lazygit/config.yml` from this repo (AI commit messages on
-- <c-a>), so the extra keys travel with the Neovim config.
local function lazygit_env()
  local ours = vim.fs.joinpath(vim.fn.stdpath('config'), 'lazygit')
  local files = {}
  local dir = vim.trim(vim.fn.system({ 'lazygit', '--print-config-dir' }))

  if vim.v.shell_error == 0 and vim.uv.fs_stat(vim.fs.joinpath(dir, 'config.yml')) then
    table.insert(files, vim.fs.joinpath(dir, 'config.yml'))
  end

  table.insert(files, vim.fs.joinpath(ours, 'config.yml'))

  return {
    LG_CONFIG_FILE = table.concat(files, ','),
    NVIM_LAZYGIT_AI_COMMIT = vim.fs.joinpath(ours, 'ai-commit.sh'),
  }
end

vim.keymap.set('n', '<leader>gg', function()
  if vim.fn.executable('lazygit') == 0 then
    vim.notify('lazygit is not installed (brew install lazygit)', vim.log.levels.WARN)
    return
  end

  lazygit = lazygit
    or require('toggleterm.terminal').Terminal:new({
      cmd = 'lazygit',
      env = lazygit_env(),
      direction = 'float',
      hidden = true,
      float_opts = { border = 'curved' },
    })

  lazygit:toggle()
end, { desc = 'Lazygit' })
