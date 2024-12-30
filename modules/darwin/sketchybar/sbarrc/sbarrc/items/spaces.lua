local colors = require("sbarrc.colors")
local icons = require("sbarrc.icons")
local settings = require("sbarrc.settings")
local app_icons = require("sbarrc.helpers.app_icons")

local spaces = {}
local space_names = {}

for i = 1, 10, 1 do
    local space = sbar.add("space", "space." .. i, {
        space = i,
        icon = {
            font = {
                family = settings.font.numbers
            },
            string = i,
            padding_left = 12,
            padding_right = 8,
            color = colors.unselected_fg2,
            highlight_color = colors.selected_fg2,
            background = {
                color = colors.transparent
            }
        },
        label = {
            padding_right = 14,
            padding_left = 0,
            color = colors.unselected_fg1,
            highlight_color = colors.selected_fg1,
            font = "sketchybar-app-font:Regular:14.0",
            y_offset = -1.5,
            background = {
                color = colors.transparent,
                border_width = 1,
                corner_radius = settings.corner_radius,
                height = settings.height,
                border_color = colors.transparent
            }
        },
        corner_radius = settings.no_corner_radius,
        padding_right = settings.no_padding,
        padding_left = settings.no_padding,
        background = {
            color = colors.transparent
        }
    })

    spaces[i] = space
    space_names[i] = space.name

    space:subscribe("space_change", function(env)
        local selected = env.SELECTED == "true"
        sbar.animate("tanh", 7, function()
            space:set({
                icon = {
                    highlight = selected
                },
                label = {
                    highlight = selected,
                    background = {
                        color = selected and colors.selected_bg1 or colors.item_bg1,
                        border_color = selected and colors.selected_fg1 or colors.transparent
                    }
                },
                background = {
                    color = selected and colors.selected_bg2 or colors.item_bg2
                }
            })
        end)

        sbar.animate("linear", 7, function()
            space:set({
                label = {
                    padding_left = selected and 8 or 0
                }
            })
        end)
    end)

    space:subscribe("mouse.clicked", function(env)
        if env.BUTTON == "other" then
            space:set({
                popup = {
                    drawing = "toggle"
                }
            })
        else
            local op = (env.BUTTON == "right") and "--destroy" or "--focus"
            sbar.exec("yabai -m space " .. op .. " " .. env.SID)
        end
    end)

    space:subscribe("mouse.exited", function(_)
        space:set({
            popup = {
                drawing = false
            }
        })
    end)
end

local everything_bracket = sbar.add("bracket", space_names, {
    background = {
        color = colors.item_bg2
    }
})

local space_window_observer = sbar.add("item", {
    drawing = false,
    updates = true
})

space_window_observer:subscribe("space_windows_change", function(env)
    local icon_line = ""
    local no_app = true
    for app, count in pairs(env.INFO.apps) do
        no_app = false
        local lookup = app_icons[app]
        local icon = ((lookup == nil) and app_icons["default"] or lookup)
        icon_line = icon_line .. " " .. icon
    end

    if (no_app) then
        icon_line = " +"
    end
    sbar.animate("tanh", 10, function()
        spaces[env.INFO.space]:set({
            label = icon_line
        })
    end)
end)
