return function(args)
  local window = args.window

  local positions = {}
  local start_line, _ = unpack(vim.api.nvim_win_get_cursor(window))
  local end_line = vim.fn.line("w0")
  for _, row in ipairs(vim.fn.range(start_line - 1, end_line, -1)) do
    table.insert(positions, {row = row, column = 0})
  end

  local column = vim.wo.numberwidth + 2
  return {
    width = vim.api.nvim_win_get_width(window) - column,
    height = start_line - end_line + 1,
    relative = "win",
    row = 0,
    column = column,
    window = window,
    positions = positions,
    offset = end_line - 1
  }
end
