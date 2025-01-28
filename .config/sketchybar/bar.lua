local colors = require("colors")
local helpers = require("helpers")

local LAPTOP_HEIGHT = 37
local DESKTOP_HEIGHT = 24

local function setup()
  sbar.bar({
    height = helpers.is_desktop() and DESKTOP_HEIGHT or LAPTOP_HEIGHT,
    color = colors.transparent,
    -- border_color = colors.b,
    shadow = false,
    sticky = true,
    padding_right = 3,
    padding_left = 3,
    -- blur_radius = 20,
    topmost = "window",
  })
end

setup()
