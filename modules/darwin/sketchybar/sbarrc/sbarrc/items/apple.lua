local colors = require("sbarrc.colors")
local icons = require("sbarrc.icons")
local settings = require("sbarrc.settings")

local apple = sbar.add("item", {
    icon = {
        string = icons.apple
    },
    label = {
        drawing = false
    },
    background = {
        color = colors.transparent
    },
    padding_right = settings.paddings + 10,
    click_script = sbmenus .. " -s 0"
})
