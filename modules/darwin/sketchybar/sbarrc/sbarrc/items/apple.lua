local colors = require("sbarrc.colors")
local icons = require("sbarrc.icons")
local settings = require("sbarrc.settings")

local apple = sbar.add("item", {
  icon = {
    font = { size = 16.0 },
    string = icons.apple,
  },
  label = { drawing = false },
  background = {
    color = colors.transparent,
  },
  click_script = sbmenus .. " -s 0"
})
