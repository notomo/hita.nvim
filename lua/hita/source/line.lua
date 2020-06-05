local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor()
  local line = vim.api.nvim_get_current_line()

  local positions = {}

  local index = 0
  repeat
    local match_start, match_end = line:find("%w+", index)
    if match_start ~= nil then
      local column = match_start - 1
      if cursor.column ~= column then
        table.insert(positions, {row = cursor.line, column = column})
      end
      index = match_end + 1
    end
  until match_start == nil

  return {
    width = window.width,
    height = 1,
    relative = "cursor",
    row = 0,
    column = -cursor.column,
    window = window.id,
    positions = positions,
    offset = cursor.line - 1
  }
end
