{

  mods.home.my.shell =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.shellAliases = {
        "sw" =
          lib.mkIf pkgs.stdenv.isDarwin "sudo darwin-rebuild switch --flake ~/systems#fruit --show-trace";
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
        };
        initContent = lib.mkIf pkgs.stdenv.isDarwin ''
          # Bind standard terminal Alt-Left/Right to word jumping
          bindkey "^[[1;3D" backward-word
          bindkey "^[[1;3C" forward-word
        '';
      };

    };

  mods.nixos.my.shell =
    {
      pkgs,
      ...
    }:
    {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    };

}
