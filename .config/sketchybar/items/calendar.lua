local theme = require("theme")
local colors = require("colors")

local clock = sbar.add("item", {
  position = "right",
  icon = { drawing = false },
  update_freq = 15,
  label = {
    font = {
      style = "Bold"
    }
  }
})

local calendar = sbar.add("item", {
  position = "right",
  icon = { drawing = false },
  update_freq = 1000,
  label = {
    color = colors.subtle,
    font = {
      size = 10,
    }
  }
})

sbar.add("bracket", { clock.name, calendar.name }, {})

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
      string = date,
    }
  })
end

clock:subscribe("routine", update_time)
clock:subscribe("forced", update_time)
calendar:subscribe("routine", update_date)
calendar:subscribe("forced", update_date)
