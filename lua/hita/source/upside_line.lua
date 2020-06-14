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
  if vim.wo.wrap then
    vim.api.nvim_win_set_cursor(0, {cursor.row, vim.fn.col("$")})
    height = vim.fn.winline()
    vim.api.nvim_win_set_cursor(0, {cursor.row, cursor.column})
  end

  return {
    cursor = cursor,
    width = window.width,
    height = height,
    row = 0,
    column = window.column,
    window = window.id,
    positions = positions,
    lines = window.upside_lines(),
    row_offset = window.first_row - 1
  }
end
