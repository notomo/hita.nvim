local util = require "hita/util"

return function(_)
  local window = util.current_window()
  local cursor = window.cursor

  local upsides = {}
  for _, row in ipairs(vim.fn.range(cursor.row - 1, window.first_row, -1)) do
    local column = util.non_space_column(row)
    table.insert(upsides, {row = row, column = column})
  end

  local downsides = {}
  for _, row in ipairs(vim.fn.range(cursor.row + 1, window.last_row)) do
    local column = util.non_space_column(row)
    table.insert(downsides, {row = row, column = column})
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

  return {
    cursor = cursor,
    width = window.width,
    height = window.height,
    row = 0,
    column = 0,
    window = window.id,
    positions = positions,
    lines = window.lines(),
    offset = window.first_row - 1
  }
end
