{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.shell.zsh;
in
{
  options.my.shell.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "gentoo";
      };
      initContent = ''
        if [[ -n "$ZELLIJ_AUTO_ATTACH" && -z "$ZELLIJ" ]]; then
            zellij attach -c; exit
        fi
      '';
    };
  };
}
