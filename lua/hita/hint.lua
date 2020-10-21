local util = require "hita/util"

local M = {}

local callbacks = {}

-- if char is included in `breakat`, wrapped line may be broken by hint.
M.chars = "asdghklqwertyuopzxcvbnmf0"
M.cancel_key = "j"

local set_backgroud_hl = function(source_window_id)
  local bg_hl_group = "Normal"
  if vim.api.nvim_win_get_config(source_window_id).relative ~= "" then
    bg_hl_group = "NormalFloat"
  end
  local guibg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(bg_hl_group)), "bg", "gui")
  if guibg == "" then
    guibg = "#334152"
  end

  local guifg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Comment")), "fg", "gui")
  if guifg == "" then
    guifg = "#8d9eb2"
  end

  local cmd = ("highlight! HitaBackground guibg=%s guifg=%s"):format(guibg, guifg)
  vim.api.nvim_command(cmd)
end

M.set_lines = function(id, bufnr, source, positions, targets)
  local ns = vim.api.nvim_create_namespace("hita")
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  for _, keymap in ipairs(vim.api.nvim_buf_get_keymap(bufnr, "n")) do
    vim.api.nvim_buf_del_keymap(bufnr, "n", keymap.lhs)
  end

  local highlights = {}
  local lines = {unpack(source.lines)}
  local children = {}
  for i, pos in ipairs(positions) do
    local target = targets[i]
    if target == nil then
      break
    end

    local row = pos.row - source.row_offset
    local replaced = lines[row]
    if replaced == nil then
      break
    end
    if pos.column >= 1 then
      lines[row] = replaced:sub(1, pos.column) .. target .. replaced:sub(pos.column + #target + 1, -1)
    else
      lines[row] = target .. replaced:sub(#target + 1, -1)
    end

    local first = target:sub(1, 1)
    if callbacks[first] == nil then
      local rhs = ("<Cmd>lua require 'hita/hint'.callback('%s')<CR>"):format(first)
      vim.api.nvim_buf_set_keymap(bufnr, "n", first, rhs, {
        noremap = true,
        nowait = true,
        silent = true,
      })
    end

    local child = children[first]
    if child == nil then
      child = {positions = {}, targets = {}}
      children[first] = child
    end

    if #target >= 2 then
      table.insert(child.targets, target:sub(2, 2))
      table.insert(child.positions, pos)
      table.insert(highlights, {row = row - 1, column = pos.column, group = "HitaTwoTargetFirst"})
      table.insert(highlights, {
        row = row - 1,
        column = pos.column + 1,
        group = "HitaTwoTargetSecond",
      })
      callbacks[first] = function()
        callbacks = {}
        M.set_lines(id, bufnr, source, child.positions, child.targets)
      end
    else
      table.insert(highlights, {row = row - 1, column = pos.column, group = "HitaTarget"})
      callbacks[first] = function()
        M.close_window(id)
        vim.api.nvim_set_current_win(source.window.id)
        vim.api.nvim_command("normal! m'")
        vim.api.nvim_win_set_cursor(source.window.id, {pos.row, pos.column})
      end
    end
  end

  local rhs = ("<Cmd>lua require 'hita/hint'.close_window(%s)<CR>"):format(id)
  vim.api.nvim_buf_set_keymap(bufnr, "n", M.cancel_key, rhs, {
    noremap = true,
    nowait = true,
    silent = true,
  })

  vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(bufnr, ns, hl.group, hl.row, hl.column, hl.column + 1)
  end
end

M.start = function(source)
  if #source.positions == 0 then
    return
  end

  local original = {
    list = vim.wo.list,
    wrap = vim.wo.wrap,
    textwidth = vim.bo.textwidth,
    listchars = vim.o.listchars,
  }

  local win_config = vim.api.nvim_win_get_config(0)
  local row = source.row
  local column = source.column
  if win_config.relative ~= "" then
    row = row + win_config.row[false]
    column = column + win_config.col[false]
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  local id = vim.api.nvim_open_win(bufnr, true, {
    width = source.width,
    height = source.height,
    relative = "win",
    row = row,
    col = column,
    bufpos = source.bufpos,
    external = false,
    style = "minimal",
  })
  source.window.copy_column_view()

  local targets = util.make_hint_targets(M.chars, #source.positions)

  callbacks = {}
  M.set_lines(id, bufnr, source, source.positions, targets)

  local on_leave = ("autocmd WinLeave,CmdlineEnter,BufLeave <buffer=%s> ++once lua require 'hita/hint'.close_window(%s)"):format(bufnr, id)
  vim.api.nvim_command(on_leave)

  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "textwidth", original.textwidth)

  local cursor = source.cursor
  vim.api.nvim_win_set_cursor(id, {cursor.row - source.row_offset, cursor.column})
  set_backgroud_hl(source.window.id)
  vim.api.nvim_win_set_option(id, "winhighlight", "Normal:HitaBackground")
  vim.api.nvim_win_set_option(id, "list", original.list)
  vim.api.nvim_win_set_option(id, "wrap", original.wrap)

  local listchars = table.concat(vim.fn.split(original.listchars, ",precedes:."))
  listchars = table.concat(vim.fn.split(listchars, ",extends:."))
  vim.api.nvim_win_set_option(id, "listchars", listchars)
end

M.callback = function(target)
  local callback = callbacks[target]
  if callback == nil then
    return
  end
  callback()
end

M.close_window = function(id)
  if id == "" then
    return
  end
  if not vim.api.nvim_win_is_valid(id) then
    return
  end
  vim.api.nvim_win_close(id, true)
end

return M
