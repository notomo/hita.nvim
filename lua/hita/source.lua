local M = {}

local sources = {}

sources.find = function(args)
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

M.sources = sources

return M
