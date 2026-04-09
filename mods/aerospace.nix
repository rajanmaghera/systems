{
  mods.darwin.aerospace.conf =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let

      allWorkspacesList = padList 8 (config.my.defaults.definedWorkspaces);

      workspaceKeyMap = builtins.listToAttrs (
        lib.concatLists (
          lib.imap1 (i: v: [
            {
              # Switching to workspace
              name = toString i;
              value = "workspace ${v}";
            }
            {
              # Movement modifications
              name = "shift-${toString i}";
              value = "move-node-to-workspace ${v}";
            }
          ]) allWorkspacesList
        )
      );

      prependWith =
        prefix: set:
        builtins.listToAttrs (
          map (key: {
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

      definedWorkspacesMap = builtins.listToAttrs (
        lib.imap1 (i: v: {
          name = v;
          value = "${toString i}-${v}";
        }) config.my.defaults.definedWorkspaces
      );

      aerospaceKeys = {
        main = config.my.defaults.windowManagerKeymaps // workspaceKeyMap;
      };

      shortcutMap =

        {
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

      w = definedWorkspacesMap;

      # To find these, run `aerospace list-apps`
      appMappings = {
        "org.mozilla.firefox" = w.web;
        "com.google.Chrome.canary" = w.web;
        "com.google.Chrome" = w.web;
        "com.tinyspeck.slackmacgap" = w.comm;
        "com.microsoft.Outlook" = w.comm;
        "com.hnc.Discord" = w.comm;
        "com.github.wez.wezterm" = w.term;
        "com.apple.Terminal" = w.term;
        "org.gnu.Emacs" = w.editor;
        "org.mozilla.thunderbird" = w.comm;
        "com.apple.iCal" = w.comm;
        "com.google.antigravity" = w.editor;
        "com.microsoft.VSCode" = w.editor;
        "com.mitchellh.ghostty" = w.term;
      };

      floatingAppIds = [
        "com.bitwarden.desktop"
        "com.apple.SecurityAgent" # Touch ID prompt
        "com.apple.LocalAuthentication.UIAgent" # Touch ID prompt
      ];

      appMappingsList = lib.attrsets.mapAttrsToList (appId: workspaceId: {
        "if".app-id = appId;
        check-further-callbacks = false;
        run = [ "move-node-to-workspace ${workspaceId}" ];
      }) appMappings;

      floatingAppIdsList = map (appId: {
        "if".app-id = appId;
        check-further-callbacks = true;
        run = [ "layout floating" ];
      }) floatingAppIds;
    in
    {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "reset-layout" ''
          #!${pkgs.bash}/bin/bash
          echo "Hi world!"
        '')
      ];
      services.aerospace = {
        enable = true;
        settings = {
          accordion-padding = 16;
          gaps = {
            inner.horizontal = 8;
            inner.vertical = 8;
            outer.left = 8;
            outer.bottom = 8;
            outer.top = 8;
            outer.right = 8;
          };
          mode = shortcutMap.aerospace;

          # App mapping to workspace must be last since it does not check further callbacks and
          # the final callback puts everything into workspace 7
          on-window-detected =
            floatingAppIdsList
            ++ appMappingsList
            ++ [
              {
                check-further-callbacks = false;
                run = [ "move-node-to-workspace ${w.scratch}" ];
              }
            ];
        };
      };
    };
}
