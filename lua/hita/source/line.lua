local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()
  local line = window.get_current_line()

  local positions = {}

  local index = 0
  repeat
    local match_start, match_end = line:find("%w+", index)
    if match_start ~= nil then
      local column = match_start - 1
      table.insert(positions, {row = cursor.row, column = column})
      index = match_end + 1
    end
  until match_start == nil

  util.remove_cursor_position(positions, cursor)

  return {
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
