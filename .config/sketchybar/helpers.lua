local _M = {}

function _M.add_margin(position)
  sbar.add("item", {
    position = position or "right",
    width = 3
  })
end

function _M.is_desktop()
  local file = io.popen("aerospace list-monitors --focused")
  if file == nil then
    return false
  end

  local output = file:read("*a")
  file:close()

  return output == "1 | LG ULTRAWIDE\n"
end

return _M
