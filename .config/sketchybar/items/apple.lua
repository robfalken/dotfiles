local icons = require("icons")
local colors = require("colors")

sbar.add("item", {
  background = {
    padding_left = 0,
    color = colors.iris,
  },
  icon = {
    font = {
      size = 12
    },
    padding_left = 4,
    padding_right = 6,
    string = icons.apple,
    color = colors.surface,
  },
  label = {
    drawing = false,
  },
})
