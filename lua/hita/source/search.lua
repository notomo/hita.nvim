local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()

  local searched = vim.fn.getreg("/")
  local pattern = vim.regex(searched)

  local positions = {}
  for _, line in ipairs(window.line_numbers()) do
    local index = 0
    repeat
      local start, e = pattern:match_line(0, line - 1, index)
      if start ~= nil and start ~= e then
        if not (cursor.column == index + start and cursor.line == line) then
          table.insert(positions, {row = line, column = index + start})
        end
        index = index + start + 1
      end
    until start == nil or start == e
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
