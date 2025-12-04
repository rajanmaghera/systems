{
  lib,
  config,
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
        if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
          if [[ -z "$ZELLIJ" ]]; then
              exec zellij attach -c main
          fi
        fi
      '';
    };
  };
}
