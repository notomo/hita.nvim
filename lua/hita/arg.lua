local M = {}

M.parse = function(raw_args)
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

return M
