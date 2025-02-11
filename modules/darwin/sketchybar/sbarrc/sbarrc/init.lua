local colors = require("sbarrc.colors")
local settings = require("sbarrc.settings")

sbar.bar({
    position = "top",
    height = 40,
    color = colors.bar.bg,
    blur_radius = colors.bar.blur
})

sbar.default({
    updates = "when_shown",
    icon = {
        height = settings.height,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 12.0
        },
        color = colors.white,
        padding_left = settings.paddings,
        padding_right = settings.paddings,
        background = {
            height = settings.height,
            image = {
                height = settings.height,
                corner_radius = settings.corner_radius
            }
        }
    },
    label = {
        height = settings.height,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Semibold"],
            size = 12.0
        },
        color = colors.white,
        padding_left = settings.paddings,
        padding_right = settings.paddings
    },
    background = {
        height = settings.height,
        corner_radius = settings.corner_radius,
        border_width = 0,
        color = colors.item_bg,
        image = {
            height = settings.height,
            corner_radius = settings.corner_radius,
            border_width = 0
        }
    },
    popup = {
        background = {
            border_width = 2,
            corner_radius = settings.corner_radius,
            border_color = colors.popup.border,
            color = colors.popup.bg,
            shadow = {
                drawing = true
            }
        },
        blur_radius = 50
    },
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    scroll_texts = true
})

require("sbarrc.items")
