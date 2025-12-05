{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.passwords;
in
{
  options.my.passwords = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-cli
      bitwarden-desktop
    ];
  };
}
