{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.my.profile;
in
{
  config = mkIf cfg.enable {
  };
}
