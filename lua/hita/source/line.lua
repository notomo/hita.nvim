return function(args)
  local window = args.window
  local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(window))
  local line = vim.api.nvim_get_current_line()

  local positions = {}

  local index = 0
  repeat
    local match_start, match_end = line:find("%w+", index)
    if match_start ~= nil then
      local column = match_start - 1
      if cursor_col ~= column then
        table.insert(positions, {row = cursor_line, column = column})
      end
      index = match_end + 1
    end
  until match_start == nil

  local column = vim.wo.numberwidth + 2
  return {
    width = vim.api.nvim_win_get_width(window) - column,
    height = 1,
    relative = "cursor",
    row = 0,
    column = -cursor_col,
    window = window,
    positions = positions,
    offset = cursor_line - 1
  }
end
