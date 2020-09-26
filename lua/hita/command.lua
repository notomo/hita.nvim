local hint = require "hita/hint"

local M = {}

M.parse_args = function(raw_args)
  args = {source_name = "window_line", window = 0}

  if #raw_args == 0 then
    return args
  end

  for _, a in ipairs(raw_args) do
    if not vim.startswith(a, "--") then
      args.source_name = a
      break
    end
  end

  return args
end

M.find_source = function(args)
  local name = ("hita/source/%s"):format(args.source_name)
  local ok, f = pcall(require, name)
  if not ok then
    return nil
  end
  return f(args)
end

M.main = function(...)
  local args = M.parse_args({...})

  local source = M.find_source(args)
  if source == nil then
    return
  end

  hint.start(source)
end

return M
