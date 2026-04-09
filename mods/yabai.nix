{
  mods.darwin.yabai.conf =
    {
      lib,
      ...
    }:
    let
      spaceMappings = [
        {
          name = "file";
          apps = [
            "Finder"
            "Logseq"
            "Preview"
            "Skim"
            "Zotero"
          ];
        }
        {
          name = "web";
          apps = [
            "Safari"
            "Chrome"
            "Firefox"
            "Zen"
            "Brave"
          ];
        }
        {
          name = "mail";
          apps = [
            "Mail"
            "Microsoft Outlook"
            "Calendar"
          ];
        }
        {
          name = "dev";
          apps = [
            "Code"
            "Ghostty"
            "iTerm2"
            "Terminal"
          ];
        }
        {
          name = "social";
          apps = [
            "Spotify"
            "Discord"
          ];
        }
        {
          name = "";
          apps = [ ];
        }
      ];

      unmanagedApps = [
        "System Settings"
      ];

      spaceCount = builtins.length spaceMappings;
      appMappingsString = lib.strings.concatImapStrings (
        i: s:
        lib.strings.concatMapStrings (x: ''
          yabai -m rule --add label="space-${x}" app="^${x}$" space=^${toString i}
          yabai -m rule --apply space-${x}
        '') s.apps
      ) spaceMappings;

      spaceCreationString = lib.strings.concatImapStrings (i: s: ''
        setup_space ${toString i} "${s.name}"
      '') spaceMappings;

      unmanagedAppsString = lib.strings.concatMapStrings (x: ''
        yabai -m rule --add app="^${x}$" manage=off
      '') unmanagedApps;
    in
    {
      services.yabai.enable = true;
      services.yabai.enableScriptingAddition = true;

      services.yabai.config = {
        top_padding = 10;
        bottom_padding = 10;
        left_padding = 10;
        right_padding = 10;
        window_gap = 10;
        layout = "bsp";
        window_shadow = "off";
        focus_follows_mouse = "autoraise";
        external_bar = "all:40:0";
      };

      services.yabai.extraConfig = ''
        for _ in $(yabai -m query --spaces | jq '.[].index | select(. > ${toString spaceCount})'); do
          yabai -m space --destroy ${toString (spaceCount + 1)}
        done

        function setup_space {
          local idx="$1"
          local name="$2"
          local space=
          echo "setup space $idx : $name"

          space=$(yabai -m query --spaces --space "$idx")
          if [ -z "$space" ]; then
            yabai -m space --create
          fi

          if [ ! -z "$name" ] ; then
            yabai -m space "$idx" --label "$name"
          fi
        }

        ${spaceCreationString}
        ${unmanagedAppsString}
        ${appMappingsString}

      '';
    };
}
