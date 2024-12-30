local colors = require("sbarrc.colors")
local icons = require("sbarrc.icons")
local settings = require("sbarrc.settings")

local popup_width = 250

local volume_percent = sbar.add("item", "widgets.volume1", {
    position = "right",
    background = {
        color = colors.transparent
    },
    label = {
        string = "??%",
        font = {
            family = settings.font.numbers
        }
    }
})

volume_percent:subscribe("volume_change", function(env)
    local volume = tonumber(env.INFO)
    local icon = icons.volume._0
    if volume > 60 then
        icon = icons.volume._100
    elseif volume > 30 then
        icon = icons.volume._66
    elseif volume > 10 then
        icon = icons.volume._33
    elseif volume > 0 then
        icon = icons.volume._10
    end

    local lead = ""
    if volume < 10 then
        lead = "0"
    end

    volume_percent:set({
        icon = icon,
        label = lead .. volume .. "%"
    })
end)

-- local function volume_scroll(env)
--   local delta = env.SCROLL_DELTA
--   sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
-- end

-- volume_icon:subscribe("mouse.clicked", volume_toggle_details)
-- volume_icon:subscribe("mouse.scrolled", volume_scroll)
-- volume_percent:subscribe("mouse.clicked", volume_toggle_details)
-- volume_percent:subscribe("mouse.exited.global", volume_collapse_details)
-- volume_percent:subscribe("mouse.scrolled", volume_scroll)
