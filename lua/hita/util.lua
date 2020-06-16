local M = {}

M.current_window = function()
  local id = 0

  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(id))
  local cursor = {
    row = cursor_row,
    column = cursor_col
  }

  local view = vim.fn.winsaveview()
  local restore_view = function()
    vim.fn.winrestview(view)
  end

  vim.api.nvim_win_set_cursor(0, {cursor.row, 0})
  local number_sign_width = vim.fn.wincol()
  restore_view()

  local first_row = vim.fn.line("w0")

  local last_row = vim.fn.line("w$")
  if vim.api.nvim_buf_line_count(0) ~= last_row then
    last_row = last_row + 1
  end

  local width = vim.api.nvim_win_get_width(id) - number_sign_width + 1
  local height = vim.api.nvim_win_get_height(id)
  local first_column = view.leftcol

  local column = 0
  if first_column >= number_sign_width then
    column = number_sign_width + 1
  elseif first_column >= 1 then
    column = first_column
  end

  return {
    first_row = first_row,
    first_column = first_column,
    last_row = last_row,
    last_column = first_column + width,
    width = width,
    height = height,
    column = column,
    bufpos = {first_row - 1, 0},
    id = id,
    lines = function()
      return vim.api.nvim_buf_get_lines(0, first_row - 1, last_row, true)
    end,
    upside_lines = function()
      return vim.api.nvim_buf_get_lines(0, first_row - 1, cursor.row, true)
    end,
    downside_lines = function()
      return vim.api.nvim_buf_get_lines(0, cursor.row - 1, last_row, true)
    end,
    rows = function()
      return vim.fn.range(first_row, last_row)
    end,
    get_current_line = function()
      return vim.api.nvim_get_current_line()
    end,
    restore_view = restore_view,
    copy_column_view = function()
      vim.fn.winrestview(
        {
          col = view.col,
          coladd = view.coladd,
          leftcol = view.leftcol,
          skipcol = view.skipcol
        }
      )
    end,
    cursor = cursor
  }
end

M.remove_position = function(positions, removed)
  for i, pos in ipairs(positions) do
    if pos.row == removed.row and pos.column == removed.column then
      table.remove(positions, i)
      return
    end
  end
end

M.remove_outside_x_position = function(positions, window)
  if vim.wo.wrap then
    return positions
  end
  local new_positions = {}
  for _, pos in ipairs(positions) do
    if window.first_column <= pos.column and pos.column <= window.last_column then
      table.insert(new_positions, pos)
    end
  end
  return new_positions
end

M.matched_positions = function(line, pattern, row)
  local positions = {}
  local index = 0
  repeat
    local s, e = line:find(pattern, index)
    if s ~= nil then
      table.insert(positions, {row = row, column = s - 1})
      index = e + 1
    end
  until s == nil
  return positions
end

M.non_space_column = function(row)
  local line = vim.fn.getline(row)
  local column = 0
  local non_space = line:find("%S")
  if non_space ~= nil then
    column = non_space - 1
  end
  return column
end

M.make_hint_targets = function(chars, positions_count)
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

return M
