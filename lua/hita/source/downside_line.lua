local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local positions = {}
  for _, row in ipairs(vim.fn.range(cursor.row + 1, window.last_row)) do
    local column = util.non_space_column(row)
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
    lines = window.downside_lines(),
    row_offset = cursor.row - 1
  }
end
