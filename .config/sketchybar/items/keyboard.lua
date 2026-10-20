local colors = require("colors")
local icons = require("icons")
local theme = require("theme")
local helpers = require("helpers")

helpers.add_margin()

sbar.add("event", "keyboard_layout_change", "AppleSelectedInputSourcesChangedNotification")

local item = sbar.add("item", {
  position = "right",
  icon = {
    string = icons.keyboard,
    color = colors.text,
  },
  label = {
    font = {
      style = "Bold",
    },
  },
})

local layouts = {
  ["U.S."] = {
    label = {
      string = "EN",
      color = colors.white,
    },
    icon = {
      color = colors.pine,
    },
    background = {
      color = colors.surface
    },
  },
  ["Swedish - Pro"] = {
    label = {
      string = "SV",
      color = colors.surface,
    },
    background = {
      color = colors.gold
    },
    icon = {
      color = colors.surface,
    },
  },
}

sbar.add("bracket", { item.name }, {})

local function update()
  sbar.exec(
    'defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -d \'"\' -f4',
    function(output)
      local layout = layouts[output:gsub("\n", "")]
      item:set(layout)
    end
  )
end

item:subscribe("keyboard_layout_change", update)
update()
