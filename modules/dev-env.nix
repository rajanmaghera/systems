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

    defaultIdentity = mkOption {
      type = types.bool;
      default = true;
      description = mkDoc ''
        Enable your default git identity using your UAlberta email.
      '';
    };

    ignoreDirenv = mkOption {
      type = types.bool;
      default = true;
      description = mkDoc ''
        Ignore direnv files globally.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = mkIf cfg.defaultIdentity "Rajan Maghera";
      userEmail = mkIf cfg.defaultIdentity "rmaghera@ualberta.ca";
      ignores = mkIf cfg.ignoreDirenv [
        ".direnv"
        ".envrc"
      ];
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

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
