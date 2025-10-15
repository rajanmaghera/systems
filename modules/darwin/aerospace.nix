{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.aerospace;
in
{
  options.my.aerospace = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services.aerospace = {
      enable = true;
      settings = {

        on-focus-changed = [
          "exec-and-forget osascript -e 'tell application id \"tracesOf.Uebersicht\" to refresh widget id \"simple-bar-index-jsx\"'"
        ];

        exec-on-workspace-change = [
          "/bin/zsh"
          "-c"
          "/usr/bin/osascript -e \"tell application id \\\"tracesOf.Uebersicht\\\" to refresh widget id \\\"simple-bar-index-jsx\\\"\""
        ];

        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "main";
          "3" = "main";
          "4" = "main";
          "5" = "main";
          "6" = [
            "secondary"
            "main"
          ];
          "7" = [
            "secondary"
            "main"
          ];
          "8" = [
            "secondary"
            "main"
          ];
          "9" = [
            "secondary"
            "main"
          ];
        };

        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };
        mode.main.binding = {
          ctrl-alt-h = "focus left";
          ctrl-alt-j = "focus down";
          ctrl-alt-k = "focus up";
          ctrl-alt-l = "focus right";

          ctrl-alt-slash = "layout tiles horizontal vertical";
          ctrl-alt-comma = "layout accordion horizontal vertical";

          ctrl-shift-h = "move left";
          ctrl-shift-j = "move down";
          ctrl-shift-k = "move up";
          ctrl-shift-l = "move right";

          ctrl-alt-minus = "resize smart -50";
          ctrl-alt-equal = "resize smart +50";

          ctrl-alt-1 = "workspace 1";
          ctrl-alt-2 = "workspace 2";
          ctrl-alt-3 = "workspace 3";
          ctrl-alt-4 = "workspace 4";
          ctrl-alt-5 = "workspace 5";
          ctrl-alt-6 = "workspace 6";
          ctrl-alt-7 = "workspace 7";
          ctrl-alt-8 = "workspace 8";
          ctrl-alt-9 = "workspace 9";

          ctrl-alt-c = "workspace code";
          ctrl-alt-w = "workspace web";
          ctrl-alt-t = "workspace term";
          ctrl-alt-s = "workspace social";
          ctrl-alt-f = "workspace files";

          ctrl-shift-1 = "move-node-to-workspace 1";
          ctrl-shift-2 = "move-node-to-workspace 2";
          ctrl-shift-3 = "move-node-to-workspace 3";
          ctrl-shift-4 = "move-node-to-workspace 4";
          ctrl-shift-5 = "move-node-to-workspace 5";
          ctrl-shift-6 = "move-node-to-workspace 6";
          ctrl-shift-7 = "move-node-to-workspace 7";
          ctrl-shift-8 = "move-node-to-workspace 8";
          ctrl-shift-9 = "move-node-to-workspace 9";

          ctrl-alt-tab = "workspace-back-and-forth";

          ctrl-shift-tab = "move-workspace-to-monitor --wrap-around next";
          ctrl-shift-semicolon = "mode service";
        };
        mode.service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ]; # reset layout
          f = [
            "layout floating tiling"
            "mode main"
          ]; # Toggle between floating and tiling layout
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];

          ctrl-shift-h = [
            "join-with left"
            "mode main"
          ];
          ctrl-shift-j = [
            "join-with down"
            "mode main"
          ];
          ctrl-shift-k = [
            "join-with up"
            "mode main"
          ];
          ctrl-shift-l = [
            "join-with right"
            "mode main"
          ];

          down = "volume down";
          up = "volume up";
          shift-down = [
            "volume set 0"
            "mode main"
          ];

        };
      };
    };
  };
}
