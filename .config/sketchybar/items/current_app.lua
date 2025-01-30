local helpers = require("helpers")
local colors = require("colors")

helpers.add_margin("left", 9)

local front_app = sbar.add("item", {
  icon = {
    drawing = false,
  },
  label = {
    padding_left = 6,
    padding_right = 5,
    font = {
      size = 12.0
    }
  },
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    padding_left = 0,
    background = {
      color = colors.transparent,
      image = {
        string = "app." .. env.INFO,
        scale = 0.75
      }
    },
    label = {
      string = env.INFO,
      padding_left = 25
    },
  })
end)
