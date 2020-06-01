local M = {}

M.root = vim.fn.getcwd()

M.command = function(cmd)
  vim.api.nvim_command(cmd)
end

M.before_each = function()
  M.command("filetype on")
  M.command("syntax enable")
end

M.after_each = function()
  M.command("tabedit")
  M.command("tabonly!")
  M.command("silent! %bwipeout!")
  M.command("filetype off")
  M.command("syntax off")
  print("\n \n")
end

M.input_key = function(key)
  vim.api.nvim_feedkeys(key, "xt", false)
end

M.set_lines = function(lines)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(lines, "\n"))
end

local assert = require("luassert")
local AM = {}

AM.window_count = function(expected)
  local actual = vim.fn.tabpagewinnr(vim.fn.tabpagenr(), "$")
  local msg = string.format("window count should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.current_line = function(expected)
  local actual = vim.fn.getline(".")
  local msg = string.format("current line should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.current_char = function(expected)
  local col = vim.fn.col(".")
  local actual = vim.fn.getline("."):sub(col, col)
  local msg = string.format("current char should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

M.assert = AM

return M
