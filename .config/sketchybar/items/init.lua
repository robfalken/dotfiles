local helpers = require("helpers")

require("items.apple")
require("items.workspaces")
require("items.current_app")

require("items.calendar")
require("items.volume")
require("items.keyboard")

if not helpers.is_desktop() then
  require("items.battery")
end
