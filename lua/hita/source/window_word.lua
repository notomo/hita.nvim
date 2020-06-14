local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  local row = window.first_row
  local lines = window.lines()
  for _, line in ipairs(lines) do
    local matched = util.matched_positions(line, "%w+", row)
    positions = vim.list_extend(positions, matched)
    row = row + 1
  end

  util.remove_position(positions, cursor)

  return {
    cursor = cursor,
    width = window.width,
    height = window.height,
    row = 0,
    column = 0,
    window = window.id,
    positions = positions,
    lines = lines,
    row_offset = window.first_row - 1
  }
end
