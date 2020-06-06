local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()
  local line = window.get_current_line()

  local positions = util.matched_positions(line, "%w+", cursor.row)
  util.remove_position(positions, cursor)

  return {
    cursor = cursor,
    width = window.width,
    height = 1,
    relative = "cursor",
    row = 0,
    column = -cursor.column,
    window = window.id,
    positions = positions,
    offset = cursor.row - 1
  }
end
