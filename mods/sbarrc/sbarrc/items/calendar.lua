local settings = require("sbarrc.settings")
local colors = require("sbarrc.colors")

local cal = sbar.add("item", {
    label = {
        font = {
            family = settings.font.numbers
        }
    },
    background = {
        color = colors.transparent
    },
    position = "right",
    update_freq = 30
})

cal:subscribe({"forced", "routine", "system_woke"}, function(env)
    cal:set({
        icon = os.date("%a %m/%d"),
        label = os.date("%H:%M")
    })
end)

local upcoming = sbar.add("item", {
    icon = {
        drawing = false
    },
    background = {
        color = colors.transparent
    },
    position = "right",
    update_freq = 30
})

upcoming:subscribe({"forced", "routine", "system_woke"}, function(env)
    sbar.exec("shortcuts run \"Get next event summary\" | cat", function(summary)
        upcoming:set({
            label = summary
        })
    end)
end)
