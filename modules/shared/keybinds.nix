{
  lib,
  ...
}:
with lib;

let
  aerospaceKeys = {
    main = {
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

    join = {

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
  };

  prependWith =
    prefix: set:
    builtins.listToAttrs (
      builtins.map (key: {
        name = "${prefix}${key}";
        value = set.${key};
      }) (builtins.attrNames set)
    );

  prependWithAlt = prependWith "alt-";
in

{
  # Set of my shortcut maps
  options.my.defaults.shortcutMap = mkOption {
    type = types.anything;
    default = {
      aerospace = {
        main.binding = {
          alt-space = "mode service";
          alt-m = "mode join";
          alt-shift-d = "mode disabled";
        }
        // (prependWithAlt aerospaceKeys.main);

        service.binding = {
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
        }
        // aerospaceKeys.main;

        join.binding = {
          esc = "mode main";
          alt-m = "mode main";
        }
        // (prependWithAlt aerospaceKeys.join);

        joinservice.binding = {
          esc = "mode main";
          m = "mode service";
        }
        // aerospaceKeys.join;

        disabled.binding = {
          alt-shift-d = "mode main";
        };

      };
    };
  };
}
