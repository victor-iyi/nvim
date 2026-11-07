-- Git: signs and hunks (gitsigns), inline blame (git-blame), commands (fugitive).
require('gitsigns').setup({
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '▁' },
    topdelete = { text = '▔' },
    changedelete = { text = '▎' },
    untracked = { text = '▎' },
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'Git: ' .. desc })
    end

    -- ]c / [c keep their native meaning inside diff mode.
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gs.nav_hunk('next')
      end
    end, 'next hunk')

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gs.nav_hunk('prev')
      end
    end, 'previous hunk')

    map('n', '<leader>hp', gs.preview_hunk_inline, 'preview hunk')
    map('n', '<leader>hs', gs.stage_hunk, 'stage hunk')
    map('n', '<leader>hr', gs.reset_hunk, 'reset hunk')
    map('n', '<leader>hd', gs.diffthis, 'diff against index')
    map({ 'o', 'x' }, 'ih', gs.select_hunk, 'select hunk')
  end,
})

require('gitblame').setup({
  enabled = true,
  date_format = '%r',
  message_when_not_committed = '',
  -- Keep blame out of the way of diagnostics' virtual text.
  virtual_text_column = 100,
})
