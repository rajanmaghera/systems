{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.tools.secrets;
in
{
  options.my.tools.secrets = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable secret management tool (agenix).";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      agenixFlake
    ];
  };
}
