return function(args)
  local window = args.window

  local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(window))

  local first_line = vim.fn.line("w0")
  local last_line = vim.fn.line("w$")

  local searched = vim.fn.getreg("/")
  local pattern = vim.regex(searched)

  local positions = {}
  for _, line in ipairs(vim.fn.range(first_line, last_line)) do
    local index = 0
    repeat
      local start, e = pattern:match_line(0, line - 1, index)
      if start ~= nil and start ~= e then
        if not (cursor_col == index + start and cursor_line == line) then
          table.insert(positions, {row = line, column = index + start})
        end
        index = index + start + 1
      end
    until start == nil or start == e
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
