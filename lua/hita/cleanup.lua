return function(base)
  local paths = vim.fn.glob(base .. "hita/**/*.lua", false, true)
  for _, path in ipairs(paths) do
    local name = path:gsub("^" .. base, "")
    name = name:gsub(".lua$", "")
    package.loaded[name] = nil
  end
end
