{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.devenv;
in {
  options.my.devenv = {
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
    ];
  };
}
