local parse = require "hita/arg".parse
local sources = require "hita/source".sources
local window = require "hita/window"

local M = {}

M.main = function(...)
  local args = parse({...})

  local source = sources.find(args)
  if source == nil then
    return
  end

  window.open(source)
end

return M
