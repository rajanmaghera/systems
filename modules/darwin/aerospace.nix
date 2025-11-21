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
        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };
        mode.main.binding = {

          alt-space = "mode service";
          alt-m = "mode join";

          alt-h = "focus --boundaries all-monitors-outer-frame left";
          alt-j = "focus --boundaries all-monitors-outer-frame down";
          alt-k = "focus --boundaries all-monitors-outer-frame up";
          alt-l = "focus --boundaries all-monitors-outer-frame right";
          alt-left = "focus --boundaries all-monitors-outer-frame left";
          alt-down = "focus --boundaries all-monitors-outer-frame down";
          alt-up = "focus --boundaries all-monitors-outer-frame up";
          alt-right = "focus --boundaries all-monitors-outer-frame right";

          alt-rightSquareBracket = "workspace next";
          alt-leftSquareBracket = "workspace prev";

          alt-period = "workspace next";
          alt-comma = "workspace prev";

          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";

          # Layout Modifications

          alt-semicolon = "layout tiles accordion";
          alt-quote = "layout tiles accordion";

          alt-slash = "layout horizontal vertical";

          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";
          alt-shift-minus = "resize smart -80";
          alt-shift-equal = "resize smart +80";

          alt-b = "balance-sizes";
          alt-r = "flatten-workspace-tree";
          alt-f = "layout floating tiling";

          # Within workspaces movement modifications

          alt-shift-h = "move --boundaries all-monitors-outer-frame left";
          alt-shift-j = "move --boundaries all-monitors-outer-frame down";
          alt-shift-k = "move --boundaries all-monitors-outer-frame up";
          alt-shift-l = "move --boundaries all-monitors-outer-frame right";
          alt-shift-left = "move --boundaries all-monitors-outer-frame left";
          alt-shift-down = "move --boundaries all-monitors-outer-frame down";
          alt-shift-up = "move --boundaries all-monitors-outer-frame up";
          alt-shift-right = "move --boundaries all-monitors-outer-frame right";

          # Movement modifications

          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";

          alt-shift-period = "move-node-to-workspace --focus-follows-window next";
          alt-shift-comma = "move-node-to-workspace --focus-follows-window prev";

          alt-shift-rightSquareBracket = "move-workspace-to-monitor --wrap-around next";
          alt-shift-leftSquareBracket = "move-workspace-to-monitor --wrap-around prev";

        };

        mode.join.binding = {
          esc = "mode main";
          alt-m = "mode main";

          alt-h = [
            "join-with left"
            "mode main"
          ];
          alt-j = [
            "join-with down"
            "mode main"
          ];
          alt-k = [
            "join-with up"
            "mode main"
          ];
          alt-l = [
            "join-with right"
            "mode main"
          ];
          alt-left = [
            "join-with left"
            "mode main"
          ];
          alt-down = [
            "join-with down"
            "mode main"
          ];
          alt-up = [
            "join-with up"
            "mode main"
          ];
          alt-right = [
            "join-with right"
            "mode main"
          ];
        };

        mode.joinservice.binding = {
          esc = "mode main";
          m = "mode service";

          h = [
            "join-with left"
            "mode service"
          ];
          j = [
            "join-with down"
            "mode service"
          ];
          k = [
            "join-with up"
            "mode service"
          ];
          l = [
            "join-with right"
            "mode service"
          ];
          left = [
            "join-with left"
            "mode service"
          ];
          down = [
            "join-with down"
            "mode service"
          ];
          up = [
            "join-with up"
            "mode service"
          ];
          right = [
            "join-with right"
            "mode service"
          ];
        };

        mode.service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          enter = [
            "reload-config"
            "mode main"
          ];

          alt-space = "mode main";
          m = "mode joinservice";

          # Movement

          h = "focus --boundaries all-monitors-outer-frame left";
          j = "focus --boundaries all-monitors-outer-frame down";
          k = "focus --boundaries all-monitors-outer-frame up";
          l = "focus --boundaries all-monitors-outer-frame right";
          left = "focus --boundaries all-monitors-outer-frame left";
          down = "focus --boundaries all-monitors-outer-frame down";
          up = "focus --boundaries all-monitors-outer-frame up";
          right = "focus --boundaries all-monitors-outer-frame right";

          period = "workspace next";
          comma = "workspace prev";

          "1" = "workspace 1";
          "2" = "workspace 2";
          "3" = "workspace 3";
          "4" = "workspace 4";
          "5" = "workspace 5";
          "6" = "workspace 6";
          "7" = "workspace 7";

          # Layout Modifications

          semicolon = "layout tiles accordion";
          quote = "layout tiles accordion";

          slash = "layout horizontal vertical";

          minus = "resize smart -50";
          equal = "resize smart +50";
          shift-minus = "resize smart -80";
          shift-equal = "resize smart +80";

          b = "balance-sizes";
          r = "flatten-workspace-tree";
          f = "layout floating tiling";

          # Within workspaces movement modifications

          shift-h = "move --boundaries all-monitors-outer-frame left";
          shift-j = "move --boundaries all-monitors-outer-frame down";
          shift-k = "move --boundaries all-monitors-outer-frame up";
          shift-l = "move --boundaries all-monitors-outer-frame right";
          shift-left = "move --boundaries all-monitors-outer-frame left";
          shift-down = "move --boundaries all-monitors-outer-frame down";
          shift-up = "move --boundaries all-monitors-outer-frame up";
          shift-right = "move --boundaries all-monitors-outer-frame right";

          # alt-shift-h = "join-with left";
          # alt-shift-j = "join-with down";
          # alt-shift-k = "join-with up";
          # alt-shift-l = "join-with right";
          # alt-shift-left = "join-with left";
          # alt-shift-down = "join-with down";
          # alt-shift-up = "join-with up";
          # alt-shift-right = "join-with right";

          # Movement modifications

          shift-1 = "move-node-to-workspace 1";
          shift-2 = "move-node-to-workspace 2";
          shift-3 = "move-node-to-workspace 3";
          shift-4 = "move-node-to-workspace 4";
          shift-5 = "move-node-to-workspace 5";
          shift-6 = "move-node-to-workspace 6";
          shift-7 = "move-node-to-workspace 7";

          shift-period = "move-node-to-workspace --focus-follows-window next";
          shift-comma = "move-node-to-workspace --focus-follows-window prev";

          shift-rightSquareBracket = "move-workspace-to-monitor --wrap-around next";
          shift-leftSquareBracket = "move-workspace-to-monitor --wrap-around prev";

        };

        ## AUTOMATIONS

        on-window-detected = [
          # Force iCloud Passwords prompt to be floating
          {
            "if".window-title-regex-substring = "iCloud Passwords";
            check-further-callbacks = true;
            run = [ "layout floating" ];
          }
        ];
      };
    };
  };
}
