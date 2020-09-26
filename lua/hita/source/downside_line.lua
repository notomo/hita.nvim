local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  local lines = window.downside_lines()
  for i, line in ipairs({unpack(lines, 2)}) do
    local row = cursor.row + i
    local column = util.non_space_column(line, window.first_column, window.last_column)
    table.insert(positions, {row = row, column = column})
  end

  local row = vim.fn.winline() - 1
  if vim.wo.wrap then
    vim.api.nvim_win_set_cursor(0, {cursor.row, 0})
    row = vim.fn.winline() - 1
    window.restore_view()
  end

  return {
    cursor = cursor,
    width = window.width,
    height = window.height - row,
    row = row,
    column = window.column,
    bufpos = window.bufpos,
    window = window,
    positions = positions,
    lines = lines,
    row_offset = cursor.row - 1,
  }
end
