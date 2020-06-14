local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  for _, row in ipairs(vim.fn.range(cursor.row + 1, window.last_row)) do
    local column = util.non_space_column(row)
    table.insert(positions, {row = row, column = column})
  end

  vim.api.nvim_win_set_cursor(0, {cursor.row, 0})
  local row = vim.fn.winline() - 1
  vim.api.nvim_win_set_cursor(0, {cursor.row, cursor.column})

  return {
    cursor = cursor,
    width = window.width,
    height = window.height - row,
    row = row,
    column = 0,
    window = window.id,
    positions = positions,
    lines = window.downside_lines(),
    row_offset = cursor.row - 1
  }
end
