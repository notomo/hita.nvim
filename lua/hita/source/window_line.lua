local Source = function(args)
  local positions = {}
  local start_line = vim.fn.line("w0")
  local end_line = vim.fn.line("w$")
  for _, row in ipairs(vim.fn.range(start_line, end_line)) do
    table.insert(positions, {row = row, column = 0})
  end

  local window = args.window
  local column = vim.wo.numberwidth + 2
  return {
    width = vim.api.nvim_win_get_width(window) - column,
    height = vim.api.nvim_win_get_height(window),
    relative = "win",
    row = 0,
    column = column,
    window = window,
    positions = positions,
    offset = start_line - 1
  }
end

return Source
