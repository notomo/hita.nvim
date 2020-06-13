local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor
  local line = window.get_current_line()

  local positions = util.matched_positions(line, "%w+", cursor.row)
  util.remove_position(positions, cursor)

  vim.api.nvim_win_set_cursor(0, {cursor.row, 0})
  local row = vim.fn.winline() - 1
  vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(window.id)[1], vim.fn.col("$")})
  local height = vim.fn.winline() - row
  vim.api.nvim_win_set_cursor(0, {cursor.row, cursor.column})

  return {
    cursor = cursor,
    width = window.width,
    height = height,
    row = row,
    column = 0,
    window = window.id,
    positions = positions,
    offset = cursor.row - 1,
    lines = {line}
  }
end
