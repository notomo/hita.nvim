local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local upsides = {}
  local upside_lines = window.upside_lines()
  for i, line in ipairs({unpack(vim.fn.reverse(upside_lines), 2)}) do
    local row = cursor.row - i
    local column = util.non_space_column(line, window.first_column, window.last_column)
    table.insert(upsides, {row = row, column = column})
  end

  local downsides = {}
  local downside_lines = {unpack(window.downside_lines(), 2)}
  for i, line in ipairs(downside_lines) do
    local row = cursor.row + i
    local column = util.non_space_column(line, window.first_column, window.last_column)
    table.insert(downsides, {row = row, column = column})
  end

  local lines = upside_lines
  vim.list_extend(lines, downside_lines)

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

  return {
    cursor = cursor,
    width = window.width,
    height = window.height,
    row = 0,
    column = window.column,
    bufpos = window.bufpos,
    window = window,
    positions = positions,
    lines = lines,
    row_offset = window.first_row - 1,
  }
end
