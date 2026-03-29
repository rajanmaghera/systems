{
  conf.mod.home =
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

        home.shellAliases = {
          "sw" = mkIf pkgs.stdenv.isDarwin "sudo darwin-rebuild switch --flake ~/systems#fruit --show-trace";
        };

        programs.zsh = {
          # Remove below line once updated to 26.05
          dotDir = "${config.xdg.configHome}/zsh";
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          oh-my-zsh = {
            enable = true;
            theme = "gentoo";
          };
          initContent = mkIf pkgs.stdenv.isDarwin ''
            # Bind standard terminal Alt-Left/Right to word jumping
            bindkey "^[[1;3D" backward-word
            bindkey "^[[1;3C" forward-word
          '';
        };
      };
    };
}
