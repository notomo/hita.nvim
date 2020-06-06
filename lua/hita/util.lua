local M = {}

M.current_window = function()
  local id = 0
  local column = vim.wo.numberwidth + 2
  local first_row = vim.fn.line("w0")
  local last_row = vim.fn.line("w$")
  local width = vim.api.nvim_win_get_width(id) - column
  return {
    first_row = first_row,
    last_row = last_row,
    width = width,
    height = vim.api.nvim_win_get_height(id),
    column = vim.api.nvim_win_get_width(id) - column,
    id = id,
    lines = function()
      local lines = {}
      for _, line in ipairs(vim.api.nvim_buf_get_lines(0, first_row - 1, last_row, true)) do
        table.insert(lines, line:sub(0, width))
      end
      return lines
    end,
    rows = function()
      return vim.fn.range(first_row, last_row)
    end,
    get_current_line = function()
      return (vim.api.nvim_get_current_line()):sub(0, width)
    end,
    cursor = function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(id))
      return {
        row = row,
        column = col
      }
    end
  }
end

M.remove_cursor_position = function(positions, cursor)
  for i, pos in ipairs(positions) do
    if pos.row == cursor.row and pos.column == cursor.column then
      table.remove(positions, i)
      return
    end
  end
end

return M
