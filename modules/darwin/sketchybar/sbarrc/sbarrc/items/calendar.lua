local settings = require("sbarrc.settings")
local colors = require("sbarrc.colors")

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    -- width = 49,
    -- align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%a. %b. %d"), label = os.date("%H:%M") })
end)
