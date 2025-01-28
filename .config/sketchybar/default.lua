local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.font.icon,
      style = "Normal",
      size = 14.0,
    },
    color = colors.text,
    padding_left = settings.padding * 2,
    padding_right = settings.padding,
    y_offset = 1,
  },
  label = {
    font = {
      family = settings.font.text,
      style = "Bold",
      size = 12.0,
    },
    color = colors.text,
    padding_left = settings.padding,
    padding_right = settings.padding * 2,
  },
  background = {
    height = 20,
    corner_radius = 3,
    border_width = 1,
    color = colors.overlay
  },
  padding_left = 0,
  padding_right = 0,
  y_offset = 0,
})
