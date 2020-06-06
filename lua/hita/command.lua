local hint = require "hita/hint"

local M = {}

M.parse_args = function(raw_args)
  args = {
    source_name = "window_line",
    window = 0
  }

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
  local name = string.format("hita/source/%s", args.source_name)
  for _, path in ipairs(vim.split(package.path, ";")) do
    local p = path:gsub("?", name)
    if vim.fn.filereadable(p) == 1 then
      local f = dofile(p)
      return f(args)
    end
  end
  return nil
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
