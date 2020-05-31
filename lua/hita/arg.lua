local M = {}

M.parse = function(raw_args)
  args = {
    source_name = "window_line",
    window = 0
  }

  if #raw_args == 0 then
    return args
  end

  return args
end

return M
