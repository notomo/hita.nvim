local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
return function(name)
  local dir = plugin_name .. "/"
  for key in pairs(package.loaded) do
    if vim.startswith(key, dir) or key == name then
      package.loaded[key] = nil
    end
  end
end
