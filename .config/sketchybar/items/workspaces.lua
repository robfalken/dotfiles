local colors = require("colors")
local icons = require("icons")
local helpers = require("helpers")

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

helpers.add_margin("left")

local function parse_string_to_table(s)
  local result = {}
  for line in s:gmatch("([^\n]+)") do
    table.insert(result, line)
  end
  return result
end

local function read_command(cmd)
  local file = io.popen(cmd)
  if file == nil then
    return
  end

  local output = file:read("*a")
  file:close()

  return output
end

local function current_workspace()
  local output = read_command("aerospace list-workspaces --focused") or ""

  return string.gsub(output, "%s+", "")
end

local function all_workspaces()
  local output = read_command("aerospace list-workspaces --all")
  if output == nil then
    return {}
  end

  return parse_string_to_table(output)
end

local function setup()
  for i, workspace in ipairs(all_workspaces()) do
    helpers.add_margin("left")
    local is_current = workspace == current_workspace()
    local space = sbar.add("item", "space." .. i, {
      background = {
        drawing = true,
        border_width = 1,
        border_color = is_current and colors.rose or colors.base
      },
      icon = {
        y_offset = 1,
        string = ws_icons[i] or workspace,
        color = colors.subtle,
        highlight_color = colors.love,
        highlight = is_current,
        padding_left = 3,
        padding_right = 3,
      },
      label = {
        drawing = true,
        string = workspace,
        padding_right = 5,
        padding_left = 2,
        color = colors.subtle,
        highlight_color = colors.white,
        highlight = is_current,
        y_offset = -1,
        font = {
          size = 10
        },
      },
    })

    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.FOCUSED_WORKSPACE == workspace
      space:set({
        icon = { highlight = selected, },
        label = { highlight = selected },
        background = {
          border_color = selected and colors.rose or colors.base
        }
      })
    end)
  end
end

setup()
