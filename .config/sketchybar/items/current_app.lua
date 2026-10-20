local helpers = require("helpers")
local colors = require("colors")

helpers.add_margin("left", 20)

local current_app_icon = sbar.add("item", {
  background = {
    color = colors.transparent,
    image = {
      scale = 0.75
    }
  },
  icon = {
    drawing = false,
  },
  label = {
    drawing = false
  },
})

local current_app_name = sbar.add("item", {
  background = {
    color = colors.highlight_low
  },
  icon = {
    drawing = false,
  },
  label = {
    font = {
      size = 12.0,
      style = "Bold"
    }
  },
})

current_app_name:subscribe("front_app_switched", function(env)
  current_app_name:set({
    label = {
      string = env.INFO,
    },
  })

  current_app_icon:set({
    background = {
      image = {
        string = "app." .. env.INFO,
      }
    },
  })
end)
