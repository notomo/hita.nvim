local M = {}

M.current_window = function()
  local id = 0

  local row, col = unpack(vim.api.nvim_win_get_cursor(id))
  local vcol = vim.fn.virtcol(".")
  local cursor = {
    row = row,
    column = col,
    virtual_column = vcol - 1
  }
  local column = vim.fn.wincol() - vcol

  local first_row = vim.fn.line("w0")
  local last_row = vim.fn.line("w$")
  local width = vim.api.nvim_win_get_width(id) - column
  return {
    first_row = first_row,
    last_row = last_row,
    width = width,
    height = vim.api.nvim_win_get_height(id),
    column = column,
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
    cursor = cursor
  }
end

M.remove_position = function(positions, removed)
  for i, pos in ipairs(positions) do
    if pos.row == removed.row and pos.column == removed.column then
      table.remove(positions, i)
      return
    end
  end
end

M.matched_positions = function(line, pattern, row)
  local positions = {}
  local index = 0
  repeat
    local s, e = line:find(pattern, index)
    if s ~= nil then
      table.insert(positions, {row = row, column = s - 1})
      index = e + 1
    end
  until s == nil
  return positions
end

return M
