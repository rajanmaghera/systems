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
      font = { family = settings.font.numbers },
      string = i,
      padding_left = 12,
      padding_right = 6,
      color = colors.grey,
      highlight_color = colors.white,
      background = {
        color = 0x00000000,
        corner_radius = 0,
        border_width = 0,
      }
    },
    label = {
      padding_right = 14,
      padding_left= 0,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:14.0",
      y_offset = -1,
      background = {
        height = 30,
        color = 0x00000000,
        corner_radius = 9,
        border_width = 1,
        border_color = colors.item_bg,
      },
    },
    corner_radius = 0,
    padding_right = 0,
    padding_left = 0,
    background = {
      color = colors.item_bg,
      color = 0x00000000,
      border_width = 0,
      height = 30,
    },
  })

  spaces[i] = space
  space_names[i] = space.name

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    sbar.animate("tanh", 7, function()
      space:set({
        icon = { highlight = selected, },
        label = { highlight = selected, background = { color = selected and colors.selected_bg1 or colors.item_bg,
        border_color = selected and colors.selected_bg2 or colors.item_bg,
      },   },
        background = {
          color = selected and colors.selected_bg2 or colors.item_bg
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
      space:set({ popup = { drawing = "toggle" } })
    else
      local op = (env.BUTTON == "right") and "--destroy" or "--focus"
      sbar.exec("yabai -m space " .. op .. " " .. env.SID)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local everything_bracket = sbar.add("bracket", space_names, {
  background = {
    color = colors.item_bg,
  }
})

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
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
    icon_line = " —"
  end
  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = icon_line })
  end)
end)
