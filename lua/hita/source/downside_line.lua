return function(args)
  local window = args.window

  local positions = {}
  local start_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(window))
  local end_line = vim.fn.line("w$")
  for _, row in ipairs(vim.fn.range(start_line + 1, end_line)) do
    table.insert(positions, {row = row, column = 0})
  end

  local column = vim.wo.numberwidth + 2
  return {
    width = vim.api.nvim_win_get_width(window) - column,
    height = end_line - start_line + 1,
    relative = "cursor",
    row = 0,
    column = -cursor_col,
    positions = positions,
    offset = start_line - 1
  }
end
