local M = {}

M.current_window = function()
  local id = 0
  local column = vim.wo.numberwidth + 2
  local first_line = vim.fn.line("w0")
  local last_line = vim.fn.line("w$")
  return {
    first_line = first_line,
    last_line = last_line,
    width = vim.api.nvim_win_get_width(id) - column,
    height = vim.api.nvim_win_get_height(id),
    column = vim.api.nvim_win_get_width(id) - column,
    id = id,
    lines = function()
      return vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, true)
    end,
    line_numbers = function()
      return vim.fn.range(first_line, last_line)
    end,
    cursor = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(id))
      return {
        line = line,
        column = col
      }
    end
  }
end

M.remove_cursor_position = function(positions, cursor)
  for i, pos in ipairs(positions) do
    if pos.row == cursor.line and pos.column == cursor.column then
      table.remove(positions, i)
      return
    end
  end
end

return M
