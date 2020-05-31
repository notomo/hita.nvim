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

M.open = function(source)
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
      win = source.window,
      row = source.row,
      col = source.column,
      external = false,
      style = "minimal"
    }
  )

  local chars = "asdghklqwertyuopzxcvbnmf;,./0"

  callbacks = {}

  local line = vim.fn["repeat"](" ", source.width)
  local lines = vim.fn["repeat"]({line}, source.height)
  for i, pos in ipairs(source.positions) do
    local char = chars:sub(i, i)
    if char == "" then
      break
    end

    local row = pos.row - source.offset
    local replaced = lines[row]
    if pos.column > 1 then
      lines[row] = replaced:sub(1, pos.column - 1) .. char .. replaced:sub(pos.column + 1, -1)
    else
      lines[row] = char .. replaced:sub(2, -1)
    end

    callbacks[char] = function()
      close_window(id)
      vim.api.nvim_set_current_win(source.window)
      vim.api.nvim_win_set_cursor(source.window, {pos.row, pos.column})
    end
    local rhs = string.format(":<C-u>lua require 'hita/window'.callback('%s')<CR>", char)
    vim.api.nvim_buf_set_keymap(bufnr, "n", char, rhs, {noremap = true, nowait = true})
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
