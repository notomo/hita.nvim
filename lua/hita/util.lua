local M = {}

M.current_window = function()
  local id = 0

  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(id))
  local cursor = {
    row = cursor_row,
    column = cursor_col
  }

  vim.api.nvim_win_set_cursor(0, {cursor_row, 0})
  local column = vim.fn.wincol()
  vim.api.nvim_win_set_cursor(0, {cursor_row, cursor_col})

  local first_row = vim.fn.line("w0")
  local last_row = vim.fn.line("w$")
  local width = vim.api.nvim_win_get_width(id) - column + 1
  local height = vim.api.nvim_win_get_height(id)

  return {
    first_row = first_row,
    last_row = last_row,
    width = width,
    height = height,
    column = column,
    id = id,
    lines = function()
      local lines = {}
      if vim.wo.wrap then
        return vim.api.nvim_buf_get_lines(0, first_row - 1, last_row, true)
      end
      for _, line in ipairs(vim.api.nvim_buf_get_lines(0, first_row - 1, last_row, true)) do
        table.insert(lines, line:sub(0, width))
      end
      return lines
    end,
    upside_lines = function()
      local lines = {}
      if vim.wo.wrap then
        return vim.api.nvim_buf_get_lines(0, first_row - 1, cursor.row, true)
      end
      for _, line in ipairs(vim.api.nvim_buf_get_lines(0, first_row - 1, cursor.row, true)) do
        table.insert(lines, line:sub(0, width))
      end
      return lines
    end,
    downside_lines = function()
      local lines = {}
      if vim.wo.wrap then
        return vim.api.nvim_buf_get_lines(0, cursor.row - 1, last_row, true)
      end
      for _, line in ipairs(vim.api.nvim_buf_get_lines(0, cursor.row - 1, last_row, true)) do
        table.insert(lines, line:sub(0, width))
      end
      return lines
    end,
    rows = function()
      return vim.fn.range(first_row, last_row)
    end,
    get_current_line = function()
      if vim.wo.wrap then
        return vim.api.nvim_get_current_line()
      end
      return (vim.api.nvim_get_current_line()):sub(0, width)
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

return M
