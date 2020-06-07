local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  for _, row in ipairs(vim.fn.range(cursor.row + 1, window.last_row)) do
    local column = util.non_space_column(row)
    table.insert(positions, {row = row, column = column})
  end

  return {
    cursor = cursor,
    width = window.width,
    height = window.last_row - cursor.row + 1,
    relative = "cursor",
    row = 0,
    column = -cursor.column,
    positions = positions,
    offset = cursor.row - 1
  }
end
