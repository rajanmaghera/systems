{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.skhd;

  appCommands = [
    {
      key = "t";
      path = "/Applications/Utilities/Terminal.app";
    }
    {
      key = "v";
      path = "${pkgs.vscode}/Applications/Visual Studio Code.app";
    }
    {
      key = "s";
      path = "/Applications/Safari.app";
    }
  ];

  spaceCount = 6;

  customCommands = [
    {
      key = "j";
      command = "yabai -m space --focus next";
    }
    {
      key = "k";
      command = "yabai -m space --focus prev";
    }
    {
      key = "m";
      command = "${pkgs.switch-mode}/bin/switch-mode";
    }
    {
      key = "u";
      command = "yabai -m space --focus ${toString spaceCount} && for id in $(yabai -m query --windows | jq '.[] | select(.[\"is-minimized\"] == true) | .id'); do yabai -m window $id --space ${toString spaceCount} --focus; done && launchctl kickstart -k gui/501/org.nixos.yabai";
    }
    {
      key = "f";
      command = "yabai -m window --toggle float";
    }
  ];

  spaceMoveCommands = map (x: {
    key = toString x;
    command = "yabai -m window --space ${toString x}";
  }) (genList (x: x + 1) spaceCount);

  commands =
    customCommands
    ++ spaceMoveCommands
    ++ (map (x: {
      key = x.key;
      command = "open -a \"${x.path}\"";
    }) appCommands);

  commandsString = strings.concatMapStrings (x: ''
    fn - ${x.key} : ${x.command}
    ctrl + alt - ${x.key} : ${x.command}
  '') commands;
in
{
  options.my.skhd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.skhd.enable = true;
    services.skhd.skhdConfig = ''
      ${commandsString}
    '';
  };
}
