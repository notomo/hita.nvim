local util = require "hita/util"

local M = {}

local callbacks = {}

-- if char is included in `breakat`, wrapped line may be broken by hint.
M.chars = "asdghklqwertyuopzxcvbnmf0"
M.cancel_key = "j"

M.start = function(source)
  if #source.positions == 0 then
    return
  end

  local original = {
    list = vim.wo.list,
    wrap = vim.wo.wrap,
    textwidth = vim.bo.textwidth
  }

  local bufnr = vim.api.nvim_create_buf(false, true)
  local id =
    vim.api.nvim_open_win(
    bufnr,
    true,
    {
      width = source.width,
      height = source.height,
      relative = "win",
      row = source.row,
      col = source.column,
      bufpos = source.bufpos,
      external = false,
      style = "minimal"
    }
  )
  source.window.copy_column_view()

  local targets = util.make_hint_targets(M.chars, #source.positions)

  callbacks = {}

  local highlights = {}
  local lines = source.lines
  for i, pos in ipairs(source.positions) do
    local target = targets[i]
    if target == nil then
      break
    end

    local row = pos.row - source.row_offset
    local replaced = lines[row]
    if replaced == nil then
      break
    end
    if pos.column >= 1 then
      lines[row] = replaced:sub(1, pos.column) .. target .. replaced:sub(pos.column + #target + 1, -1)
    else
      lines[row] = target .. replaced:sub(#target + 1, -1)
    end

    table.insert(highlights, {row = row - 1, column = pos.column, group = "HitaTarget"})
    if #target >= 2 then
      table.insert(highlights, {row = row - 1, column = pos.column + 1, group = "HitaSecondTarget"})
    end

    callbacks[target] = function()
      M.close_window(id)
      vim.api.nvim_set_current_win(source.window.id)
      vim.api.nvim_command("normal! m'")
      vim.api.nvim_win_set_cursor(source.window.id, {pos.row, pos.column})
    end
    local rhs = (":<C-u>lua require 'hita/hint'.callback('%s')<CR>"):format(target)
    vim.api.nvim_buf_set_keymap(bufnr, "n", target, rhs, {noremap = true, nowait = true, silent = true})
  end

  local rhs = (":<C-u>lua require 'hita/hint'.close_window(%s)<CR>"):format(id)
  vim.api.nvim_buf_set_keymap(bufnr, "n", M.cancel_key, rhs, {noremap = true, nowait = true, silent = true})

  local on_leave = ("autocmd WinLeave <buffer=%s> ++once lua require 'hita/hint'.close_window(%s)"):format(bufnr, id)
  vim.api.nvim_command(on_leave)

  local on_cmdline_enter =
    ("autocmd CmdlineEnter <buffer=%s> ++once lua require 'hita/hint'.close_window(%s)"):format(bufnr, id)
  vim.api.nvim_command(on_cmdline_enter)

  local on_move =
    ("autocmd CursorMoved <buffer=%s> ++once autocmd CursorMoved <buffer=%s> ++once lua require 'hita/hint'.close_window(%s)"):format(
    bufnr,
    bufnr,
    id
  )
  vim.api.nvim_command(on_move)

  local on_buf_leave =
    ("autocmd BufLeave <buffer=%s> ++once lua require 'hita/hint'.close_window(%s)"):format(bufnr, id)
  vim.api.nvim_command(on_buf_leave)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "textwidth", original.textwidth)

  local ns = vim.api.nvim_create_namespace("hita")
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(bufnr, ns, hl.group, hl.row, hl.column, hl.column + 1)
  end

  local cursor = source.cursor
  vim.api.nvim_win_set_cursor(id, {cursor.row - source.row_offset, cursor.column})
  vim.api.nvim_win_set_option(id, "winhighlight", "Normal:HitaBackground")
  vim.api.nvim_win_set_option(id, "list", original.list)
  vim.api.nvim_win_set_option(id, "wrap", original.wrap)
end

M.callback = function(target)
  local callback = callbacks[target]
  if callback == nil then
    return
  end
  callback()
end

M.close_window = function(id)
  if id == "" then
    return
  end
  if not vim.api.nvim_win_is_valid(id) then
    return
  end
  vim.api.nvim_win_close(id, true)
end

return M
