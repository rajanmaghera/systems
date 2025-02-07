{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.latex;
in {
  options.my.latex = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.texlive.combined.scheme-full
    ];
  };
}
