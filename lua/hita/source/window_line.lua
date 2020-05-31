return function(args)
  local window = args.window

  local cursor_line, _ = unpack(vim.api.nvim_win_get_cursor(window))

  local upsides = {}
  local first_line = vim.fn.line("w0")
  for _, row in ipairs(vim.fn.range(cursor_line - 1, first_line, -1)) do
    table.insert(upsides, {row = row, column = 0})
  end

  local downsides = {}
  local last_line = vim.fn.line("w$")
  for _, row in ipairs(vim.fn.range(cursor_line + 1, last_line)) do
    table.insert(downsides, {row = row, column = 0})
  end

  local side_a = upsides
  local side_b = downsides
  if #upsides < #downsides then
    side_a = downsides
    side_b = upsides
  end

  local positions = {}
  for i, pos in ipairs(side_a) do
    table.insert(positions, pos)

    if side_b[i] ~= nil then
      table.insert(positions, side_b[i])
    end
  end

  local column = vim.wo.numberwidth + 2
  return {
    width = vim.api.nvim_win_get_width(window) - column,
    height = vim.api.nvim_win_get_height(window),
    relative = "win",
    row = 0,
    column = column,
    window = window,
    positions = positions,
    offset = first_line - 1
  }
end
