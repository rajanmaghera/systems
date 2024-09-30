{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.yabai;
in {
  options.my.yabai = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.yabai.enable = true;
    services.yabai.enableScriptingAddition = true;

    services.yabai.config = {
      top_padding = 14;
      bottom_padding = 14;
      left_padding = 14;
      right_padding = 14;
      window_gap = 14;
      layout = "bsp";
      window_shadow = "off";
      focus_follows_mouse = "autoraise";
      external_bar = "all:40:0";
    };
  };
}
