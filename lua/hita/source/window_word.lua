local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()

  local positions = {}
  local row = window.first_row
  for _, line in ipairs(window.lines()) do
    local index = 0
    repeat
      local match_start, match_end = line:find("%w+", index)
      if match_start ~= nil then
        local column = match_start - 1
        table.insert(positions, {row = row, column = column})
        index = match_end + 1
      end
    until match_start == nil
    row = row + 1
  end

  util.remove_cursor_position(positions, cursor)

  return {
    cursor = cursor,
    width = window.width,
    height = window.height,
    relative = "win",
    row = 0,
    column = window.column,
    window = window.id,
    positions = positions,
    offset = window.first_row - 1
  }
end
