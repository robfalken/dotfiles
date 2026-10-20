local icons = require("icons")
local colors = require("colors")
local helpers = require("helpers")

helpers.add_margin()

local volume = sbar.add("item", {
  position = "right",
  label = {
    font = {
      style = "Bold"
    },
    padding_left = 2,
  },
  icon = {
    color = colors.love,
    string = icons.volume._10,
    padding_right = 4,
  },
})

volume:subscribe("volume_change", function(env)
  local percentage = tonumber(env.INFO)
  local icon = icons.volume._0
  local color = colors.pine
  local background = colors.gold
  local is_muted = percentage == 0

  if percentage == 100 then
    icon = icons.volume._100
    color = colors.love
  elseif percentage > 60 then
    color = colors.gold
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
  if is_muted then
    color = colors.surface
    background = colors.love
    drawing = false
  else
    background = colors.surface
    drawing = true
  end

  volume:set({
    background = { color = background },
    label = {
      string = text,
      drawing = drawing,
    },
    icon = { string = icon, color = color },
  })
end)
