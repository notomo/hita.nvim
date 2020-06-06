local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()

  local searched = vim.fn.getreg("/")
  local pattern = vim.regex(searched)

  local positions = {}
  for _, row in ipairs(window.rows()) do
    local index = 0
    repeat
      -- TODO: match_line(0, row - 1, index, window.width) with avoiding `invalid end`
      local start, e = pattern:match_line(0, row - 1, index)
      if start ~= nil and start ~= e then
        table.insert(positions, {row = row, column = index + start})
        index = index + start + 1
      end
    until start == nil or start == e
  end

  util.remove_cursor_position(positions, cursor)

  return {
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
