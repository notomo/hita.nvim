local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()

  local positions = {}
  for _, row in ipairs(vim.fn.range(cursor.line - 1, window.first_line, -1)) do
    table.insert(positions, {row = row, column = 0})
  end

  return {
    width = window.width,
    height = cursor.line - window.first_line + 1,
    relative = "win",
    row = 0,
    column = window.column,
    window = window.id,
    positions = positions,
    offset = window.first_line - 1
  }
end
