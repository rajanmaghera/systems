{
  lib,
  config,
  ...
}:
with lib;

let
  workspaceKeyMap = builtins.listToAttrs (
    lib.concatLists (
      lib.imap1 (i: v: [
        {
          # Switching to workspace
          name = builtins.toString i;
          value = "workspace ${v}";
        }
        {
          # Movement modifications
          name = "shift-${builtins.toString i}";
          value = "move-node-to-workspace ${v}";
        }
      ]) config.my.defaults.allWorkspacesList
    )
  );

  aerospaceKeys = {
    main = {
      # Movement

      h = "focus --boundaries all-monitors-outer-frame left";
      j = "focus --boundaries all-monitors-outer-frame down";
      k = "focus --boundaries all-monitors-outer-frame up";
      l = "focus --boundaries all-monitors-outer-frame right";

      period = "workspace next";
      comma = "workspace prev";

      # Layout Modifications

      semicolon = "layout tiles accordion";
      quote = "layout tiles accordion";

      slash = "layout horizontal vertical";

      minus = "resize smart -50";
      equal = "resize smart +50";
      shift-minus = "resize smart -80";
      shift-equal = "resize smart +80";

      shift-b = "balance-sizes";
      shift-r = "flatten-workspace-tree";
      shift-f = "layout floating tiling";

      # Within workspaces movement modifications

      shift-h = "move --boundaries all-monitors-outer-frame left";
      shift-j = "move --boundaries all-monitors-outer-frame down";
      shift-k = "move --boundaries all-monitors-outer-frame up";
      shift-l = "move --boundaries all-monitors-outer-frame right";

      shift-period = "move-node-to-workspace --focus-follows-window next";
      shift-comma = "move-node-to-workspace --focus-follows-window prev";

      shift-rightSquareBracket = "move-workspace-to-monitor --wrap-around next";
      shift-leftSquareBracket = "move-workspace-to-monitor --wrap-around prev";

      # join
      ctrl-h = "join-with left";
      ctrl-j = "join-with down";
      ctrl-k = "join-with up";
      ctrl-l = "join-with right";

    }
    // workspaceKeyMap;

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

  padList =
    length: inputList:
    let
      inputLen = builtins.length inputList;
      padLen = length - inputLen;
      padding = builtins.genList (i: toString (i + inputLen + 1)) (if padLen > 0 then padLen else 0);
    in
    lib.take length ((lib.imap1 (i: v: "${toString i}-${v}") inputList) ++ padding);
in

{
  # Setup workspaces
  options.my.defaults.definedWorkspaces = mkOption {
    type = types.anything;
    default = [
      "web"
      "comm"
      "term"
      "editor"
      "scratch"
    ];
  };

  options.my.defaults.definedWorkspacesMap = mkOption {
    type = types.anything;
    default = builtins.listToAttrs (
      lib.imap1 (i: v: {
        name = v;
        value = "${toString i}-${v}";
      }) config.my.defaults.definedWorkspaces
    );
    readOnly = true;
  };

  options.my.defaults.allWorkspacesList = mkOption {
    type = types.anything;
    default = padList 8 (config.my.defaults.definedWorkspaces);
    readOnly = true;
  };

  # Set of my shortcut maps
  options.my.defaults.shortcutMap = mkOption {
    type = types.anything;
    default = {
      aerospace = {
        main.binding = {
          alt-space = "mode service";
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
        }
        // aerospaceKeys.main;

        disabled.binding = {
          alt-shift-d = "mode main";
        };

      };
    };
  };
}
