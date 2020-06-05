local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()

  local positions = {}
  for _, row in ipairs(vim.fn.range(cursor.line + 1, window.last_line)) do
    table.insert(positions, {row = row, column = 0})
  end

  return {
    width = window.width,
    height = window.last_line - cursor.line + 1,
    relative = "cursor",
    row = 0,
    column = -cursor.column,
    positions = positions,
    offset = cursor.line - 1
  }
end
