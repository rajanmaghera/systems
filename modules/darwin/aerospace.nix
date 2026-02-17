{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.aerospace;
  w = config.my.defaults.definedWorkspacesMap;

  # To find these, run aerospace list-apps
  appMappings = {
    "org.mozilla.firefox" = w.web;
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
  ];

  appMappingsList = attrsets.mapAttrsToList (appId: workspaceId: {
    "if".app-id = appId;
    check-further-callbacks = false;
    run = [ "move-node-to-workspace ${workspaceId}" ];
  }) appMappings;

  floatingAppIdsList = builtins.map (appId: {
    "if".app-id = appId;
    check-further-callbacks = true;
    run = [ "layout floating" ];
  }) floatingAppIds;
in
{
  options.my.aerospace = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
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
        mode = config.my.defaults.shortcutMap.aerospace;

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
