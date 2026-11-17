-- "How do I ...?" → a shell command, typed into the terminal for you to review and run.
--
-- Used from the <leader>ft shell (<C-g>) or anywhere else (<leader>c?). The request and the
-- terminal's recent output go to Claude (`claude -p`, fast model, no tools), so "why did
-- that fail?" or "undo my last commit" work too. Nothing runs until you press <Enter>.
local M = {}

local SYSTEM_PROMPT = [[
You turn a request into ONE shell command for the user's terminal.
Reply with the command only: one line, no explanation, no markdown, no code fences.
Chain steps with && when several are needed. Prefer safe, standard tools.
If the request is unclear or impossible, reply with a shell comment starting with "# ".
]]

local function context(buf)
  local lines = {}

  local os = vim.uv.os_uname()
  table.insert(lines, ('OS: %s %s (%s)'):format(os.sysname, os.release, os.machine))
  table.insert(lines, 'Shell: ' .. vim.fn.fnamemodify(vim.o.shell, ':t'))
  table.insert(lines, 'Working directory: ' .. vim.fn.getcwd())

  if vim.fs.root(vim.fn.getcwd(), '.git') then
    table.insert(lines, 'Inside a git repository.')
  end

  -- The terminal's last screenful, for requests about what just happened.
  if buf and vim.api.nvim_buf_is_valid(buf) then
    local output = vim.api.nvim_buf_get_lines(buf, math.max(0, vim.api.nvim_buf_line_count(buf) - 60), -1, false)
    local text = vim.trim(table.concat(output, '\n'))

    if text ~= '' then
      table.insert(lines, 'Recent terminal output:\n' .. text)
    end
  end

  return table.concat(lines, '\n')
end

-- First real line of the reply, without fences or a leading `$ `.
local function extract_command(text)
  for _, line in ipairs(vim.split(text or '', '\n', { trimempty = true })) do
    line = vim.trim(line)

    if line ~= '' and not line:match('^```') then
      return (line:gsub('^%$%s+', ''))
    end
  end
end

-- The <leader>ft terminal (opened if needed), or the given terminal buffer.
local function terminal_buffer(buf)
  if buf and vim.api.nvim_buf_is_valid(buf) then
    return buf
  end

  local term = require('toggleterm.terminal').get(1)

  if not (term and term:is_open()) then
    require('toggleterm').toggle(1)
    term = require('toggleterm.terminal').get(1)
  end

  return term and term.bufnr
end

local function type_into(buf, command)
  local job = vim.b[buf].terminal_job_id

  if not job then
    vim.notify('AI: no terminal to type into', vim.log.levels.WARN)
    return
  end

  local win = vim.fn.bufwinid(buf)

  if win ~= -1 then
    vim.api.nvim_set_current_win(win)
  end

  vim.api.nvim_chan_send(job, command)
  vim.cmd.startinsert()
end

---@param opts? { buf?: integer } Terminal buffer to type into (default: the <leader>ft shell)
function M.ask(opts)
  opts = opts or {}

  if vim.fn.executable('claude') == 0 then
    vim.notify('AI: Claude Code is not installed (https://claude.com/claude-code)', vim.log.levels.WARN)
    return
  end

  local from_terminal = opts.buf ~= nil
  vim.cmd.stopinsert()

  vim.ui.input({ prompt = 'What do you want to do? ' }, function(request)
    if not request or vim.trim(request) == '' then
      if from_terminal then
        vim.cmd.startinsert()
      end

      return
    end

    local progress = vim.api.nvim_echo({ { 'Asking Claude for a command…' } }, false, {
      kind = 'progress',
      source = 'ai',
      status = 'running',
      title = 'AI',
    })

    local input = context(opts.buf) .. '\n\nRequest: ' .. request

    vim.system({
      'claude',
      '-p',
      '--model',
      'haiku',
      '--tools',
      '',
      '--no-session-persistence',
      '--system-prompt',
      SYSTEM_PROMPT,
    }, { stdin = input, text = true, cwd = vim.fn.getcwd() }, function(result)
      vim.schedule(function()
        local ok = result.code == 0
        local command = ok and extract_command(result.stdout)

        vim.api.nvim_echo({ { ok and 'Done' or 'Failed' } }, false, {
          id = progress,
          kind = 'progress',
          source = 'ai',
          status = ok and 'success' or 'failed',
          title = 'AI',
        })

        if not command then
          local message = vim.trim((result.stdout or '') .. '\n' .. (result.stderr or ''))

          if message:find('login', 1, true) or message:find('Not logged in', 1, true) then
            message = message .. '\nSign in once by running `claude` in a terminal and typing /login.'
          end

          vim.notify('AI: ' .. (message ~= '' and message or 'no answer'), vim.log.levels.WARN)
          return
        end

        local buf = terminal_buffer(opts.buf)

        if buf then
          type_into(buf, command)
        end
      end)
    end)
  end)
end

return M
