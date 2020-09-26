local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  local lines = window.upside_lines()
  for i, line in ipairs({unpack(vim.fn.reverse(lines), 2)}) do
    local row = cursor.row - i
    local column = util.non_space_column(line, window.first_column, window.last_column)
    table.insert(positions, {row = row, column = column})
  end

  local height = vim.fn.winline()
  if vim.wo.wrap then
    vim.api.nvim_win_set_cursor(0, {cursor.row, vim.fn.col("$")})
    height = vim.fn.winline()
    window.restore_view()
  end

  return {
    cursor = cursor,
    width = window.width,
    height = height,
    row = 0,
    column = window.column,
    bufpos = window.bufpos,
    window = window,
    positions = positions,
    lines = lines,
    row_offset = window.first_row - 1,
  }
end
