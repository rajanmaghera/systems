{

  mods.home.shell.conf =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.shellAliases = {
        "sw" =
          lib.mkIf pkgs.stdenv.isDarwin "sudo darwin-rebuild switch --flake ~/Projects/systems#fruit --show-trace";
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


          # Shell function for quickly launching editor layout
          ze() {
            if [[ -z "$1" ]]; then
              echo "Usage: ze <project-folder>"
              return 1
            fi
            
            zellij action new-tab --layout "$HOME/editor.kdl" --cwd "$HOME/Projects/$1" --name "editor/$1"
          }
          _ze_completion() {
            _arguments '1:project:_files -W "$HOME/Projects" -/'
          }
          compdef _ze_completion ze

          # Shell function for connecting to any of my remotes' zellij instances
          gssh() {
            if [[ -z "$1" ]]; then
              echo "Usage: gssh <ssh-host>"
              return 1
            fi
            
            ghostty -e ssh -t "$1" "zsh -l -c 'zellij attach -c main'" >/dev/null 2>&1 &
          }
          compdef gssh=ssh
        '';
      };

    };

  mods.nixos.shell.conf =
    {
      pkgs,
      ...
    }:
    {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
    };

}
