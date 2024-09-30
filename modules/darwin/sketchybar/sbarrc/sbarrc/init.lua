local colors = require("sbarrc.colors")
local settings = require("sbarrc.settings")

sbar.bar({
  position = "top",
  height = 40,
  color = colors.bar.bg,
})

sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    background = { image = { corner_radius = 9 } },
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
    height = 30,
    corner_radius = 9,
    border_width = 0,
    color = colors.item_bg,
    image = {
      corner_radius = 9,
      border_width = 0
    }
  },
  popup = {
    background = {
      border_width = 2,
      corner_radius = 9,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 50,
  },
  padding_left = settings.paddings,
  padding_right = settings.paddings,
  scroll_texts = true,
})

require("sbarrc.items")
