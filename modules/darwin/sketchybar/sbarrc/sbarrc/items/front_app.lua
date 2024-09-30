local colors = require("sbarrc.colors")
local settings = require("sbarrc.settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = {
    background = {
      drawing = true,
      image = {
        border_width = 0,
      }
    },
  },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
    front_app:set({
      label = { string = env.INFO },
      icon = { background = {
        image = "app." .. env.INFO } }
    })
end)
