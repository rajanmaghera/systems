{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.docker;
in
{
  options.my.docker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Docker as a backend";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
  };
}
