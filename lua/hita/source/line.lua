local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor
  local line = window.get_current_line()

  local positions = util.matched_positions(line, "%w+", cursor.row)
  util.remove_position(positions, cursor)
  positions = util.remove_outside_x_position(positions, window)

  local row = vim.fn.winline() - 1
  local height = 1
  if vim.wo.wrap then
    vim.api.nvim_win_set_cursor(0, {cursor.row, 0})
    row = vim.fn.winline() - 1
    vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(window.id)[1], vim.fn.col("$")})
    height = vim.fn.winline() - row
    window.restore_view()
  end

  return {
    cursor = cursor,
    width = window.width,
    height = height,
    row = row,
    column = window.column,
    bufpos = window.bufpos,
    window = window,
    positions = positions,
    row_offset = cursor.row - 1,
    lines = {line}
  }
end
