local icons = require("sbarrc.icons")
local colors = require("sbarrc.colors")
local settings = require("sbarrc.settings")

local battery = sbar.add("item", "widgets.battery", {
    position = "right",
    background = {
        color = colors.transparent
    },
    label = {
        font = {
            family = settings.font.numbers
        }
    },
    update_freq = 180,
    popup = {
        align = "center"
    }
})

local remaining_time = sbar.add("item", {
    position = "popup." .. battery.name,
    icon = {
        string = "Time remaining:",
        width = 100,
        align = "left"
    },
    label = {
        string = "??:??h",
        width = 100,
        align = "right"
    }
})

battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
    sbar.exec("pmset -g batt", function(batt_info)
        local icon = "!"
        local label = "?"

        item = string.find(batt_info, "AC Power")
        label = item and "AC Power" or "Battery Power"

        local found, _, charge = batt_info:find("(%d+)%%")
        if found then
            charge = tonumber(charge)
            label = charge .. "%"
        end

        local color = colors.white
        local charging, _, _ = batt_info:find("AC Power")

        if charging then
            icon = icons.battery.charging
        else
            if found and charge > 80 then
                icon = icons.battery._100
            elseif found and charge > 60 then
                icon = icons.battery._75
            elseif found and charge > 40 then
                icon = icons.battery._50
            elseif found and charge > 20 then
                icon = icons.battery._25
            else
                icon = icons.battery._0
            end
        end

        local lead = ""
        if found and charge < 10 then
            lead = ""
        end

        battery:set({
            icon = {
                string = icon,
                color = color
            },
            label = {
                string = lead .. label
            }
        })
    end)
end)

battery:subscribe("mouse.clicked", function(env)
    local drawing = battery:query().popup.drawing
    battery:set({
        popup = {
            drawing = "toggle"
        }
    })

    if drawing == "off" then
        sbar.exec("pmset -g batt", function(batt_info)
            local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
            local label = found and remaining .. "h" or "No estimate"
            remaining_time:set({
                label = label
            })
        end)
    end
end)
