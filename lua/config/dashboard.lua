-- Start screen for a bare `nvim`: file tree on the left, welcome + quick actions + recent
-- files in the main window. Opening any file replaces it.
local M = {}

local api = vim.api
local ns = api.nvim_create_namespace('config.dashboard')

local HEADER = {
  '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
}

-- Every row of the menu and recent-files list is padded to this width so they align.
local BLOCK_WIDTH = 52
local MAX_RECENT = 8

local function telescope(picker, opts)
  return function()
    require('telescope.builtin')[picker](opts)
  end
end

-- Single-key actions; `hint` shows the global mapping that does the same thing.
local ACTIONS = {
  { key = 'f', icon = '\u{f15b}', label = 'Find file', hint = '␣ff', run = telescope('find_files') },
  { key = 's', icon = '\u{f002}', label = 'Find text', hint = '␣fs', run = telescope('live_grep') },
  { key = 'r', icon = '\u{f1da}', label = 'Recent files', hint = '', run = telescope('oldfiles', { only_cwd = true }) },
  {
    key = 'e',
    icon = '\u{f07b}',
    label = 'File tree',
    hint = '␣e',
    run = function()
      vim.cmd('NvimTreeFocus')
    end,
  },
  {
    key = 'n',
    icon = '\u{f067}',
    label = 'New file',
    hint = '',
    run = function()
      vim.cmd.enew()
    end,
  },
  {
    key = 'g',
    icon = '\u{f1d3}',
    label = 'Lazygit',
    hint = '␣gg',
    run = function()
      api.nvim_feedkeys(vim.keycode('<leader>gg'), 'm', false)
    end,
  },
  {
    key = 'c',
    icon = '\u{f013}',
    label = 'Config',
    hint = '',
    run = telescope('find_files', { cwd = vim.fn.stdpath('config') }),
  },
  {
    key = 'u',
    icon = '\u{f021}',
    label = 'Update plugins',
    hint = '',
    run = function()
      vim.pack.update()
    end,
  },
  {
    key = 'm',
    icon = '\u{f0ad}',
    label = 'Mason',
    hint = '',
    run = function()
      vim.cmd('Mason')
    end,
  },
  {
    key = 'q',
    icon = '\u{f011}',
    label = 'Quit',
    hint = '',
    run = function()
      vim.cmd('qa')
    end,
  },
}

-- ── Highlights ──────────────────────────────────────────────────────────────────────────

-- Header fades blue → violet, the same accents as the statusline's normal/visual modes.
local function gradient(from, to, steps)
  local function channel(c, shift)
    return math.floor(c / 2 ^ shift) % 256
  end

  local colors = {}

  for i = 0, steps - 1 do
    local t = steps > 1 and i / (steps - 1) or 0
    local rgb = 0

    for _, shift in ipairs({ 16, 8, 0 }) do
      local a, b = channel(from, shift), channel(to, shift)
      rgb = rgb + math.floor(a + (b - a) * t + 0.5) * 2 ^ shift
    end

    colors[#colors + 1] = rgb
  end

  return colors
end

local function set_highlights()
  for i, color in ipairs(gradient(0x65D1FF, 0xFF61EF, #HEADER)) do
    api.nvim_set_hl(0, 'DashboardHeader' .. i, { fg = color, bold = true })
  end

  local links = {
    DashboardGreeting = 'Title',
    DashboardSection = 'Label',
    DashboardKey = 'Number',
    DashboardIcon = 'Function',
    DashboardLabel = 'Normal',
    DashboardHint = 'Comment',
    DashboardPath = 'Comment',
    DashboardFooter = 'Comment',
  }

  for group, target in pairs(links) do
    api.nvim_set_hl(0, group, { link = target, default = true })
  end
end

-- ── Content ─────────────────────────────────────────────────────────────────────────────

local function greeting()
  local hour = tonumber(os.date('%H'))
  local part = hour < 12 and 'morning' or hour < 18 and 'afternoon' or 'evening'
  local user = (vim.env.USER or ''):gsub('^%l', string.upper)

  return user ~= '' and ('Good %s, %s'):format(part, user) or ('Good ' .. part)
end

local function git_branch()
  local head = vim.fs.find('HEAD', { path = vim.fn.getcwd(), upward = true, type = 'file', limit = 1 })[1]
  local file = head and io.open(head)

  if not file then
    return nil
  end

  local ref = file:read('*l') or ''
  file:close()

  return ref:match('ref: refs/heads/(.+)') or ref:sub(1, 7)
end

-- Readable files from `:oldfiles`, those inside the working directory first.
local function recent_files()
  local cwd = vim.fn.getcwd() .. '/'
  local inside, outside = {}, {}

  for _, path in ipairs(vim.v.oldfiles) do
    if #inside >= MAX_RECENT then
      break
    end

    if vim.uv.fs_stat(path) and not path:find('/%.git/') then
      table.insert(vim.startswith(path, cwd) and inside or outside, path)
    end
  end

  return vim.list_slice(vim.list_extend(inside, outside), 1, MAX_RECENT)
end

-- Pads `text` on the right to `width` display cells.
local function pad(text, width)
  return text .. string.rep(' ', math.max(width - vim.fn.strdisplaywidth(text), 0))
end

-- Builds the lines, their highlight spans, which rows are actionable, and which rows sit
-- in the left-aligned block (the rest are centred on their own).
local function build(width)
  local lines, marks, items, block = {}, {}, {}, {}

  local function add(text, spans, in_block)
    lines[#lines + 1] = text
    block[#lines] = in_block or nil

    for _, span in ipairs(spans or {}) do
      marks[#marks + 1] = { #lines, span[1], span[2], span[3] }
    end
  end

  -- The art needs ~52 columns; narrow windows get a one-line title instead.
  if width >= BLOCK_WIDTH + 4 then
    for i, row in ipairs(HEADER) do
      add(row, { { 0, #row, 'DashboardHeader' .. i } }, true)
    end
  else
    add('Neovim', { { 0, 6, 'DashboardHeader1' } })
  end

  local version = vim.version()
  local subtitle = ('v%d.%d.%d'):format(version.major, version.minor, version.patch)
  local branch = git_branch()
  local where = vim.fn.fnamemodify(vim.fn.getcwd(), ':~') .. (branch and ('  \u{e0a0} ' .. branch) or '')

  add('')
  add(greeting(), { { 0, -1, 'DashboardGreeting' } })
  local info = subtitle .. '  ·  ' .. where
  local room = width - 4

  -- Long working directories keep their tail, which is the part that identifies them.
  if vim.fn.strdisplaywidth(info) > room then
    info = '…' .. vim.fn.strcharpart(info, vim.fn.strchars(info) - room + 1)
  end

  add(info, { { 0, -1, 'DashboardPath' } })
  add('')

  for _, action in ipairs(ACTIONS) do
    local left = ('  %s  %s'):format(action.icon, action.label)
    local right = (action.hint ~= '' and action.hint .. '   ' or '') .. action.key
    local row = pad(left, BLOCK_WIDTH - vim.fn.strdisplaywidth(right)) .. right
    local icon_end = 2 + #action.icon

    add(row, {
      { 2, icon_end, 'DashboardIcon' },
      { icon_end, #left, 'DashboardLabel' },
      { #row - #right, #row - 1, 'DashboardHint' },
      { #row - 1, #row, 'DashboardKey' },
    }, true)
    items[#lines] = action.run
  end

  local recent = recent_files()

  if #recent > 0 then
    add('')
    add('Recent files', { { 0, -1, 'DashboardSection' } }, true)

    local devicons = require('nvim-web-devicons')

    for i, path in ipairs(recent) do
      local name = vim.fn.fnamemodify(path, ':t')
      local icon, icon_hl = devicons.get_icon(name, vim.fn.fnamemodify(name, ':e'), { default = true })
      local shown = vim.fn.fnamemodify(path, ':~:.')
      local max = BLOCK_WIDTH - 10

      if vim.fn.strdisplaywidth(shown) > max then
        shown = '…' .. shown:sub(-(max - 1))
      end

      local left = ('  %s  %s'):format(icon, shown)
      local row = pad(left, BLOCK_WIDTH - 1) .. tostring(i)
      local icon_end = 2 + #icon

      add(row, {
        { 2, icon_end, icon_hl },
        { icon_end, #left, 'DashboardPath' },
        { #row - 1, #row, 'DashboardKey' },
      }, true)
      items[#lines] = function()
        vim.cmd.edit(vim.fn.fnameescape(path))
      end
    end
  end

  local ms = vim.g.config_start_ns and (vim.uv.hrtime() - vim.g.config_start_ns) / 1e6
  local plugins = #vim.pack.get(nil, { info = false })

  add('')
  add(
    ('%d plugins'):format(plugins) .. (ms and (' · ready in %d ms'):format(math.floor(ms + 0.5)) or ''),
    { { 0, -1, 'DashboardFooter' } }
  )

  return lines, marks, items, block
end

-- ── Rendering ───────────────────────────────────────────────────────────────────────────

local state = {} ---@type { buf: integer?, items: table<integer, function>, rows: integer[] }

local function render(buf, win)
  if not api.nvim_win_is_valid(win) or api.nvim_win_get_buf(win) ~= buf then
    return
  end

  local width, height = api.nvim_win_get_width(win), api.nvim_win_get_height(win)
  local lines, marks, items, block = build(width)

  -- Centre the block as a unit; greeting, path and footer are centred individually.
  local left = math.max(math.floor((width - BLOCK_WIDTH) / 2), 0)
  local top = math.max(math.floor((height - #lines) / 2), 0)
  local out, shift = {}, {}

  for i = 1, top do
    out[i] = ''
  end

  for i, line in ipairs(lines) do
    local w = vim.fn.strdisplaywidth(line)
    local indent = block[i] and left or math.max(math.floor((width - w) / 2), 0)
    out[top + i] = string.rep(' ', indent) .. line
    shift[i] = indent
  end

  vim.bo[buf].modifiable = true
  api.nvim_buf_set_lines(buf, 0, -1, false, out)
  vim.bo[buf].modifiable = false
  api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for _, mark in ipairs(marks) do
    local row, s, e, group = mark[1], mark[2], mark[3], mark[4]
    local line = out[top + row]
    local col = shift[row] + s
    local end_col = e < 0 and #line or shift[row] + e

    api.nvim_buf_set_extmark(buf, ns, top + row - 1, col, { end_col = end_col, hl_group = group })
  end

  state.items, state.rows = {}, {}

  for i = 1, #lines do
    if items[i] then
      state.items[top + i] = items[i]
      state.rows[#state.rows + 1] = top + i
    end
  end

  -- Keep the cursor on the key column of an actionable row.
  local cursor = api.nvim_win_get_cursor(win)[1]

  if not state.items[cursor] and state.rows[1] then
    api.nvim_win_set_cursor(win, { state.rows[1], #out[state.rows[1]] - 1 })
  end

  api.nvim_win_call(win, function()
    vim.fn.winrestview({ leftcol = 0 })
  end)
end

-- Moves to the next/previous actionable row.
local function step(delta)
  return function()
    local cursor = api.nvim_win_get_cursor(0)[1]
    local rows = state.rows
    local target = rows[delta > 0 and 1 or #rows]

    for i = (delta > 0 and 1 or #rows), (delta > 0 and #rows or 1), delta do
      if (delta > 0 and rows[i] > cursor) or (delta < 0 and rows[i] < cursor) then
        target = rows[i]
        break
      end
    end

    api.nvim_win_set_cursor(0, { target, #api.nvim_get_current_line() - 1 })
  end
end

function M.open()
  local win = api.nvim_get_current_win()
  local initial = api.nvim_get_current_buf()
  local buf = api.nvim_create_buf(false, true)

  state.buf = buf
  vim.bo[buf].filetype = 'dashboard'
  vim.bo[buf].bufhidden = 'wipe'
  pcall(api.nvim_buf_set_name, buf, 'Welcome')
  api.nvim_win_set_buf(win, buf)

  -- Window-local settings for this buffer only; the next file gets the normal ones back.
  for option, value in pairs({
    number = false,
    relativenumber = false,
    signcolumn = 'no',
    foldcolumn = '0',
    colorcolumn = '',
    cursorline = false,
    list = false,
    spell = false,
    wrap = false,
    -- The cursor rests on the last column; a side margin would scroll the art sideways.
    sidescrolloff = 0,
    statuscolumn = '',
    winbar = '',
  }) do
    vim.wo[win][0][option] = value
  end

  -- Drop the empty [No Name] buffer so <Left>/<Right> don't cycle back to it.
  if api.nvim_buf_is_valid(initial) and api.nvim_buf_get_name(initial) == '' and not vim.bo[initial].modified then
    pcall(api.nvim_buf_delete, initial, {})
  end

  local function map(lhs, rhs)
    vim.keymap.set('n', lhs, rhs, { buffer = buf, nowait = true, silent = true })
  end

  for _, action in ipairs(ACTIONS) do
    map(action.key, action.run)
  end

  for i = 1, MAX_RECENT do
    map(tostring(i), function()
      local target = state.rows[#ACTIONS + i]
      local run = target and state.items[target]

      if run then
        run()
      end
    end)
  end

  map('j', step(1))
  map('k', step(-1))
  map('<CR>', function()
    local run = state.items[api.nvim_win_get_cursor(0)[1]]

    if run then
      run()
    end
  end)

  M.redraw()

  -- Re-centre when the tree opens/closes or the terminal (tmux pane) resizes.
  api.nvim_create_autocmd({ 'WinResized', 'VimResized' }, {
    group = api.nvim_create_augroup('config.dashboard.resize', { clear = true }),
    callback = function()
      if not api.nvim_buf_is_valid(buf) then
        return true
      end

      M.redraw()
    end,
  })
end

--- Re-lays out the start screen in every window showing it.
function M.redraw()
  if state.buf and api.nvim_buf_is_valid(state.buf) then
    for _, win in ipairs(vim.fn.win_findbuf(state.buf)) do
      render(state.buf, win)
    end
  end
end

-- Only for a bare `nvim` with a UI: not `nvim file`, `nvim .`, `cmd | nvim -` or scripts.
local function should_open()
  return vim.fn.argc(-1) == 0
    and #api.nvim_list_uis() > 0
    and not vim.g.config_started_with_stdin
    and api.nvim_buf_get_name(0) == ''
    and api.nvim_buf_line_count(0) == 1
    and api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''
end

local group = api.nvim_create_augroup('config.dashboard', { clear = true })

api.nvim_create_autocmd('StdinReadPre', {
  group = group,
  callback = function()
    vim.g.config_started_with_stdin = true
  end,
})

api.nvim_create_autocmd('ColorScheme', { group = group, callback = set_highlights })
set_highlights()

api.nvim_create_autocmd('VimEnter', {
  group = group,
  desc = 'Start screen and file tree for a bare `nvim`',
  nested = true,
  callback = function()
    if not should_open() then
      return
    end

    M.open()

    local win = api.nvim_get_current_win()
    require('nvim-tree.api').tree.open()

    if api.nvim_win_is_valid(win) then
      api.nvim_set_current_win(win)
    end

    -- The tree took width before the first redraw, so WinResized never fires for it.
    M.redraw()
  end,
})

return M
