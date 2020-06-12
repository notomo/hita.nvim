local M = {}

local callbacks = {}

M.close_window = function(id)
  if id == "" then
    return
  end
  if not vim.api.nvim_win_is_valid(id) then
    return
  end
  vim.api.nvim_win_close(id, true)
end

local make_targets = function(chars, positions_count)
  local char_count = #chars
  local remaining = positions_count - char_count

  local all_chars = vim.split(chars, "")
  if remaining < 0 then
    return all_chars
  end

  local pair_count = math.floor(remaining / char_count + 1)
  local single_chars = chars:sub(0, -pair_count - 1)

  local targets = {}
  if single_chars ~= "" then
    targets = vim.split(single_chars, "")
  end

  local pair_chars = chars:sub(-pair_count, -1)
  for _, head_char in ipairs(vim.split(pair_chars, "")) do
    for _, char in ipairs(all_chars) do
      table.insert(targets, head_char .. char)
    end
  end

  return targets
end

M.chars = "asdghklqwertyuopzxcvbnmf;,./0"
M.cancel_key = "j"

M.start = function(source)
  if #source.positions == 0 then
    return
  end

  local original = {
    list = vim.wo.list
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
      bufpos = {vim.fn.line("w0") - 1, 0},
      external = false,
      style = "minimal"
    }
  )

  local targets = make_targets(M.chars, #source.positions)

  callbacks = {}

  local highlights = {}
  local lines = source.lines
  for i, pos in ipairs(source.positions) do
    local target = targets[i]
    if target == nil then
      break
    end

    local row = pos.row - source.offset
    local replaced = lines[row]
    if pos.column > 1 then
      lines[row] = replaced:sub(1, pos.column) .. target .. replaced:sub(pos.column + #target + 1, -1)
    else
      lines[row] = target .. replaced:sub(#target + 1, -1)
    end
    table.insert(highlights, {row = row - 1, column = pos.column, target = target})

    callbacks[target] = function()
      M.close_window(id)
      vim.api.nvim_set_current_win(source.window)
      vim.api.nvim_command("normal! m'")
      vim.api.nvim_win_set_cursor(source.window, {pos.row, pos.column})
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

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

  local ns = vim.api.nvim_create_namespace("hita")
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(bufnr, ns, "HitaTarget", hl.row, hl.column, hl.column + #hl.target)
  end

  local cursor = source.cursor
  vim.api.nvim_win_set_cursor(id, {cursor.row - source.offset, cursor.column})
  vim.api.nvim_win_set_option(id, "winhighlight", "Normal:HitaBackground")
  vim.api.nvim_win_set_option(id, "scrolloff", 0)
  vim.api.nvim_win_set_option(id, "sidescrolloff", 0)
  vim.api.nvim_win_set_option(id, "list", original.list)
end

M.callback = function(target)
  local callback = callbacks[target]
  if callback == nil then
    return
  end
  callback()
end

return M
