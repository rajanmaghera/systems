{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  # Due to a bug in 5.4.7, we need to use 5.4.4 for sketchybar
  lua5_4_4 = pkgs.lua5_4.override {
    version = "5.4.4";
    hash = "sha256-Fkx4SWU7gK5nvsS3RzuIS/XMjS3KBWU0dewu0nuev2E=";
  };
  cfg = config.my.sketchybar;
in {
  options.my.sketchybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.sketchybar.enable = true;
    services.sketchybar.config = ''
      #!${lua5_4_4}/bin/lua

      -- Add the sketchybar module to the package cpath (the module could be
      -- installed into the default search path then this would not be needed)
      package.cpath = package.cpath .. ";${pkgs.sbarlua}/lib/lua/5.4/?.so"
      package.path = package.path .. ";${./sbarrc}/?.lua;${./sbarrc}/?/init.lua"

      sbmenus = "${pkgs.sbmenus}/bin/sbmenus"

      sbar = require("sketchybar")
      sbar.begin_config()
      require("sbarrc")
      sbar.end_config()
      sbar.event_loop()
    '';
  };
}
