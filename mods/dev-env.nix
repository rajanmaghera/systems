{ lb, ... }:
{

  ops.home.my.dev-env.defaultIdentity =
    lb.opt.bool true "Enable default username and password for git";

  mods.home.my.dev-env =
    {
      cfg,
      pkgs,
      lib,
      ...
    }:
    {
      programs.git = {
        enable = true;
        ignores = [
          ".direnv"
          ".envrc"
          ".DS_Store"
          "justfile"
        ];
        settings = {
          user.name = lib.mkIf cfg.defaultIdentity "Rajan Maghera";
          user.email = lib.mkIf cfg.defaultIdentity "maghera@cs.toronto.edu";
          core.fsmonitor = true;
          rebase.updateRefs = true;
          merge.conflictstyle = "diff3";
        };
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      home.sessionVariables = {
        EDITOR = "hx";
      };

      programs.helix = {
        enable = true;
        settings = {
          editor.line-number = "relative";
          keys.normal = {
            # use yazi to pick files
            # TODO: fix yazi output messing up the main buffer
            space.o = [
              ":sh rm -f /tmp/unique-file"
              ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-file"
              ":sh printf \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
              ":open %sh{cat /tmp/unique-file}"
              ":redraw"
              ":set mouse false"
              ":set mouse true"
            ];
          };
        };
      };

      programs.zellij = {
        enable = true;
        settings = {
          default_shell = "${pkgs.zsh}/bin/zsh";
          show_startup_tips = false;
          session_serialization = false;
          support_kitty_keyboard_protocol = true;
        };
      };

      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

        settings = {
          command = "${pkgs.zsh}/bin/zsh -l -c \"${pkgs.zellij}/bin/zellij attach -c main\"";
          confirm-close-surface = false;
          quit-after-last-window-closed = true;
          macos-option-as-alt = true;

          keybind = [
            "alt+[=unbind"
            "alt+]=unbind"
            "alt+left=unbind"
            "alt+right=unbind"
          ];
        };
      };

      programs.jujutsu.enable = true;
      programs.jujutsu.settings = {
        user.name = lib.mkIf cfg.defaultIdentity "Rajan Maghera";
        user.email = lib.mkIf cfg.defaultIdentity "maghera@cs.toronto.edu";
        spr.branchPrefix = "rajanmaghera/";
      };

      programs.yazi.enable = true;
      # Remove after 26.05
      programs.yazi.shellWrapperName = "y";

      home.packages = [
        # VCS tools
        pkgs.lazygit
        pkgs.lazyjj
        pkgs.gh
        # Terminal tools
        pkgs.ripgrep
        pkgs.watchman
        pkgs.just
      ];
    };
}
