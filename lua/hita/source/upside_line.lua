local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  for _, row in ipairs(vim.fn.range(cursor.row - 1, window.first_row, -1)) do
    local column = util.non_space_column(row)
    table.insert(positions, {row = row, column = column})
  end

  local height = vim.fn.winline()
  if vim.api.nvim_buf_line_count(0) ~= cursor.row then
    vim.api.nvim_win_set_cursor(0, {cursor.row + 1, 0})
    height = vim.fn.winline() - 1
    vim.api.nvim_win_set_cursor(0, {cursor.row, cursor.column})
  end

  return {
    cursor = cursor,
    width = window.width,
    height = height,
    row = 0,
    column = 0,
    window = window.id,
    positions = positions,
    lines = window.upside_lines(),
    offset = window.first_row - 1
  }
end
