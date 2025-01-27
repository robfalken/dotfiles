local colors = require("colors")
local icons = require("icons")

local ws_icons = {
  icons.workspaces.home,    -- 0
  icons.workspaces.misc,    -- 1
  icons.workspaces.misc,    -- 2
  icons.workspaces.misc,    -- 3
  icons.workspaces.notes,   -- 4
  icons.workspaces.photo,   -- 5
  icons.workspaces.music,   -- 6
  icons.workspaces.message, -- 7
  icons.workspaces.code,    -- 8
  icons.workspaces.browser, -- 9
}

local function parse_string_to_table(s)
  local result = {}
  for line in s:gmatch("([^\n]+)") do
    table.insert(result, line)
  end
  return result
end

local current_file = io.popen("aerospace list-workspaces --focused")
local current_output = current_file:read("*a")
current_file:close()
local current_workspace = string.gsub(current_output, "%s+", "")


local all_file = io.popen("aerospace list-workspaces --all")
local all_output = all_file:read("*a")
all_file:close()

local workspaces = parse_string_to_table(all_output)
for i, workspace in ipairs(workspaces) do
  local space = sbar.add("item", "space." .. i, {
    icon = {
      string = ws_icons[i] or workspace,
      color = colors.white,
      highlight_color = colors.love,
      highlight = workspace == current_workspace
    },
    label = { drawing = true },
    padding_left = 1,
    padding_right = 1,
  })

  space:subscribe("aerospace_workspace_change", function(env)
    local selected = env.FOCUSED_WORKSPACE == workspace
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
      background = { border_color = selected and colors.white or colors.bg2 }
    })
  end)
end
