local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = "Symbols Nerd Font Mono",
      style = "Normal",
      size = 14.0,
    },
    color = colors.text,
    padding_left = 4,
    padding_right = 0,
    y_offset = 1,
  },
  label = {
    font = {
      family = "Futura",
      style = "Normal",
      size = 10.0,
    },
    color = colors.text,
    padding_left = 6,
    padding_right = 6,
  },
  background = {
    height = 20,
    corner_radius = 3,
    border_width = 1,
    color = colors.surface
  },
  padding_left = 0,
  padding_right = 0,
  y_offset = 0,
})
