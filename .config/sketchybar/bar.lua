local colors = require("colors")

sbar.bar({
  height = 37,
  -- color = colors.surface,
  border_color = colors.b,
  -- shadow = true,
  sticky = true,
  padding_right = 10,
  padding_left = 10,
  -- blur_radius = 20,
  topmost = "window",
})
