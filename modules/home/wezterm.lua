-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Monokai (dark) (terminal.sexy)'
  else
    return 'Harmonic16 Light (base16)'
  end
end

-- or, changing the font size and color scheme.
config.font_size = 12
config.font = wezterm.font 'Fragment Mono'
config.color_scheme = scheme_for_appearance(get_appearance())
config.enable_tab_bar = false

-- Finally, return the configuration to wezterm:
return config
