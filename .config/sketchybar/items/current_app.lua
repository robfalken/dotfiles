local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local theme = require("theme")
local helpers = require("helpers")

helpers.add_margin("left", 9)

local front_app = sbar.add("item", {
  padding_left = 0,
  icon = {
    drawing = true,
    padding_left = 3,
    color = colors.pine
  },
  label = {
    padding_left = 6,
    padding_right = 3,
  },
})

sbar.add("bracket", { front_app.name }, theme.bracket)

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    icon = {
      string = icons["apps"][env.INFO] or icons.window,
    },
    label = {
      string = env.INFO,
    },
  })
end)
