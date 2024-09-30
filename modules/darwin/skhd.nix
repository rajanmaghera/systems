{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.skhd;
in {
  options.my.skhd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.skhd.enable = true;
    services.skhd.skhdConfig = ''
      fn - j : yabai -m space --focus next
      fn - k : yabai -m space --focus prev
      fn - n : yabai -m space --focus next
      fn - p : yabai -m space --focus prev
      fn - c : yabai -m space --create
      fn - d : yabai -m space --destroy
      fn - 1 : yabai -m window --space 1
      fn - 2 : yabai -m window --space 2
      fn - 3 : yabai -m window --space 3
      fn - 4 : yabai -m window --space 4
      fn - 5 : yabai -m window --space 5
      fn - 6 : yabai -m window --space 6
      fn - 7 : yabai -m window --space 7
      fn - 8 : yabai -m window --space 8
      fn - 9 : yabai -m window --space 9

      ctrl + alt - j : yabai -m space --focus next
      ctrl + alt - k : yabai -m space --focus prev
      ctrl + alt - n : yabai -m space --focus next
      ctrl + alt - p : yabai -m space --focus prev
      ctrl + alt - c : yabai -m space --create
      ctrl + alt - d : yabai -m space --destroy
      ctrl + alt - 1 : yabai -m window --space 1
      ctrl + alt - 2 : yabai -m window --space 2
      ctrl + alt - 3 : yabai -m window --space 3
      ctrl + alt - 4 : yabai -m window --space 4
      ctrl + alt - 5 : yabai -m window --space 5
      ctrl + alt - 6 : yabai -m window --space 6
      ctrl + alt - 7 : yabai -m window --space 7
      ctrl + alt - 8 : yabai -m window --space 8
      ctrl + alt - 9 : yabai -m window --space 9
    '';
  };
}
