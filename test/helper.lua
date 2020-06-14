local M = {}

M.root = vim.fn.getcwd()

M.command = function(cmd)
  vim.api.nvim_command(cmd)
end

M.before_each = function()
  require "hita/hint".chars = "asdghklqwertyuopzxcvbnmf0"
  M.command("filetype on")
  M.command("syntax enable")
end

M.after_each = function()
  M.command("tabedit")
  M.command("tabonly!")
  M.command("silent! %bwipeout!")
  M.command("filetype off")
  M.command("syntax off")
  print(" ")
end

M.input_key = function(key)
  M.command("normal " .. key)
end

M.jump_before = function()
  M.input_key("``")
end

M.set_lines = function(lines)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(lines, "\n"))
end

M.cursor = function()
  return {vim.fn.line("."), vim.fn.col(".")}
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

AM.cursor = function(expected)
  local actual = M.cursor()
  local msg = string.format("cursor positon should be %s, but actual: %s", expected, actual)
  assert.same(expected, actual, msg)
end

AM.column = function(expected)
  local actual = vim.fn.col(".")
  local msg = string.format("column should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.window_height = function(expected)
  local actual = vim.api.nvim_win_get_height(0)
  local msg = string.format("window height should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.window_relative_row = function(expected)
  local actual = vim.fn.winline()
  local msg = string.format("window relative line should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

M.assert = AM

return M
