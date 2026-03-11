local colors = require("sbarrc.colors")
local settings = require("sbarrc.settings")

local front_app = sbar.add("item", "front_app", {
    display = "active",
    icon = {
        background = {
            drawing = true,
            color = colors.transparent
        }
    },
    background = {
        color = colors.transparent
    },
    updates = true
})

front_app:subscribe("front_app_switched", function(env)
    front_app:set({
        label = {
            string = env.INFO
        },
        icon = {
            background = {
                image = "app." .. env.INFO
            }
        }
    })
end)
