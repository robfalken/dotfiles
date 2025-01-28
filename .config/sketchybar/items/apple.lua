local icons = require("icons")
local colors = require("colors")

sbar.add("item", {
  padding_right = 3,
  background = {
    drawing = false
  },
  icon = {
    string = icons.apple,
    color = colors.gold,
  },
  label = {
    drawing = true,
  },
})
