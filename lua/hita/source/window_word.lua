return function(args)
  local window = args.window

  local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(window))

  local first_line = vim.fn.line("w0")
  local last_line = vim.fn.line("w$")
  local lines = vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, true)

  local positions = {}
  local line_index = first_line
  for _, line in ipairs(lines) do
    local index = 0
    repeat
      local match_start, match_end = line:find("%w+", index)
      if match_start ~= nil then
        local column = match_start - 1
        if not (cursor_col == column and cursor_line == line) then
          table.insert(positions, {row = line_index, column = column})
        end
        index = match_end + 1
      end
    until match_start == nil
    line_index = line_index + 1
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
