local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  for _, row in ipairs(vim.fn.range(cursor.row + 1, window.last_row)) do
    local column = util.non_space_column(row)
    table.insert(positions, {row = row, column = column})
  end

  local row = vim.fn.winline() - 1
  if vim.api.nvim_buf_line_count(0) ~= cursor.row then
    vim.api.nvim_win_set_cursor(0, {cursor.row, 0})
    local start_row = vim.fn.winline()
    row = start_row - 1
    vim.api.nvim_win_set_cursor(0, {cursor.row, cursor.column})
  end

  return {
    cursor = cursor,
    width = window.width,
    height = window.height - row,
    row = row,
    column = 0,
    window = window.id,
    positions = positions,
    lines = window.downside_lines(),
    offset = cursor.row - 1
  }
end
