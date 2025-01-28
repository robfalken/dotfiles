local icons = require("icons")
local colors = require("colors")
local theme = require("theme")
local helpers = require("helpers")

helpers.add_margin()

local volume = sbar.add("item", {
  position = "right",
  background = theme.bracket.background,
  icon = {
    color = colors.love,
    string = icons.volume._10,
    padding_right = 6,
    padding_left = 3,
  },
})

volume:subscribe("volume_change", function(env)
  local percentage = tonumber(env.INFO)
  local icon = icons.volume._0
  local color = colors.gold
  local background = theme.bracket.background.color

  if percentage > 60 then
    icon = icons.volume._100
  elseif percentage > 30 then
    icon = icons.volume._66
  elseif percentage > 10 then
    icon = icons.volume._33
  elseif percentage > 0 then
    icon = icons.volume._10
  end

  local text = percentage .. "%"
  local drawing = true
  if percentage == 0 then
    color = colors.base
    background = colors.love
    drawing = false
  else
    color = colors.pine
    background = colors.overlay
    drawing = true
  end

  volume:set({
    background = { color = background },
    label = {
      string = text,
      drawing = drawing,
      padding_right = 3,
      font = {
        size = 12,
        style = "Bold"
      }
    },
    icon = { string = icon, color = color, y_offset = 1 },
  })
end)
