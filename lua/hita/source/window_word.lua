local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()

  local positions = {}
  local line_index = window.first_line
  for _, line in ipairs(window.lines()) do
    local index = 0
    repeat
      local match_start, match_end = line:find("%w+", index)
      if match_start ~= nil then
        local column = match_start - 1
        if not (cursor.column == column and cursor.line == line) then
          table.insert(positions, {row = line_index, column = column})
        end
        index = match_end + 1
      end
    until match_start == nil
    line_index = line_index + 1
  end

  return {
    width = window.width,
    height = window.height,
    relative = "win",
    row = 0,
    column = window.column,
    window = window.id,
    positions = positions,
    offset = window.first_line - 1
  }
end
