{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.dev-env;
in {
  options.my.dev-env = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git-branchless
      git-absorb
      lazygit
      nodejs
      glab
      gh
    ];
  };
}
