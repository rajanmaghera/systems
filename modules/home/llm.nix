{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.llm;
in {
  options.my.llm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ollama
    ];
  };
}
