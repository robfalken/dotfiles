local theme = require("theme")
local colors = require("colors")

local clock = sbar.add("item", {
  padding_left = 5,
  padding_right = 5,
  icon = { drawing = false },
  label = {
    font = {
      -- size = 12,
      -- style = "Bold",
    },
  },
  position = "right",
  update_freq = 15,
})

local calendar = sbar.add("item", {
  icon = { drawing = false },
  padding_right = 0,
  padding_left = 5,
  y_offset = -1,
  position = "right",
  update_freq = 15,
  label = {
    font = {
      size = 10,
      color = colors.love
    }
  }
})

sbar.add("bracket", { clock.name, calendar.name }, {
  background = theme.bracket.background,
})

local function update_time()
  local time = os.date("%H:%M")
  clock:set({
    label = {
      string = time,
    }
  })
end

local function update_date()
  local date = os.date("%a %d %b")
  calendar:set({
    label = {
      font = {
        style = "Normal"
      },
      string = date,
      color = colors.subtle
    }
  })
end

clock:subscribe("routine", update_time)
clock:subscribe("forced", update_time)
calendar:subscribe("routine", update_date)
calendar:subscribe("forced", update_date)
