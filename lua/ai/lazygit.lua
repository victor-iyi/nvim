-- Called by `lazygit/ai-commit.sh` (over Neovim's RPC socket) once Claude's commit message is
-- waiting in .git/LAZYGIT_PENDING_COMMIT: presses `c` in lazygit so its commit box opens with
-- the message filled in. The short delay lets lazygit finish the command and refresh first.
local M = {}

local function lazygit_job()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.bo[buf].buftype == 'terminal'
      and vim.api.nvim_buf_get_name(buf):find('lazygit', 1, true)
      and vim.b[buf].terminal_job_id
    then
      return vim.b[buf].terminal_job_id
    end
  end
end

---@param pending string Path of the pending-message file, removed once lazygit has read it
---  (lazygit doesn't always remove it after committing, and would offer it again next time;
---  pressing <esc> in the commit box still saves your edits back to it).
function M.open_commit_box(pending)
  vim.defer_fn(function()
    local job = lazygit_job()

    if not job then
      return
    end

    vim.api.nvim_chan_send(job, 'c')

    vim.defer_fn(function()
      local content = pending and io.open(pending, 'r')

      if content then
        local text = content:read('*a')
        content:close()

        -- Only our message: anything lazygit wrote back on <esc> is yours to keep.
        if text == M.last_message then
          os.remove(pending)
        end
      end
    end, 1500)
  end, 400)

  if pending then
    local file = io.open(pending, 'r')
    M.last_message = file and file:read('*a')

    if file then
      file:close()
    end
  end

  return ''
end

return M
