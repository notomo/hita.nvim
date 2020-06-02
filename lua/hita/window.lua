local M = {}

local callbacks = {}

local close_window = function(id)
  if id == "" then
    return
  end
  if not vim.api.nvim_win_is_valid(id) then
    return
  end
  vim.api.nvim_win_close(id, true)
end

local target_chars = function(chars, positions_count)
  local char_count = #chars
  local remaining = positions_count - char_count

  local all_chars = vim.split(chars, "")
  if remaining < 0 then
    return all_chars
  end

  local pair_count = math.floor(remaining / char_count + 1)
  local single_chars = chars:sub(0, -pair_count - 1)

  local results = {}
  if single_chars ~= "" then
    results = vim.split(single_chars, "")
  end

  local pair_chars = chars:sub(-pair_count, -1)
  for _, head_char in ipairs(vim.split(pair_chars, "")) do
    for _, char in ipairs(all_chars) do
      table.insert(results, head_char .. char)
    end
  end

  return results
end

M.chars = "asdghklqwertyuopzxcvbnmf;,./0"

M.open = function(source)
  if #source.positions == 0 then
    return
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  local cursor = vim.api.nvim_win_get_cursor(0)

  local id =
    vim.api.nvim_open_win(
    bufnr,
    true,
    {
      width = source.width,
      height = source.height,
      relative = source.relative,
      row = source.row,
      col = source.column,
      external = false,
      style = "minimal"
    }
  )

  local chars = target_chars(M.chars, #source.positions)

  callbacks = {}

  local line = (" "):rep(source.width)
  local lines = vim.fn["repeat"]({line}, source.height)
  for i, pos in ipairs(source.positions) do
    local char = chars[i]
    if char == nil then
      break
    end

    local row = pos.row - source.offset
    local replaced = lines[row]
    if pos.column > 1 then
      lines[row] = replaced:sub(1, pos.column) .. char .. replaced:sub(pos.column + 1, -1)
    else
      lines[row] = char .. replaced:sub(2, -1)
    end

    callbacks[char] = function()
      close_window(id)
      vim.api.nvim_set_current_win(source.window)
      vim.api.nvim_win_set_cursor(source.window, {pos.row, pos.column})
    end
    local rhs = string.format(":<C-u>lua require 'hita/window'.callback('%s')<CR>", char)
    vim.api.nvim_buf_set_keymap(bufnr, "n", char, rhs, {noremap = true, nowait = true, silent = true})
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

  vim.api.nvim_win_set_cursor(id, {cursor[1] - source.offset, cursor[2]})
  vim.api.nvim_win_set_option(id, "winhighlight", "Normal:HitaTarget")
  vim.api.nvim_win_set_option(id, "winblend", 40)
  vim.api.nvim_win_set_option(id, "scrolloff", 0)
  vim.api.nvim_win_set_option(id, "sidescrolloff", 0)
end

M.callback = function(char)
  local callback = callbacks[char]
  if callback == nil then
    return
  end
  callback()
end

return M
