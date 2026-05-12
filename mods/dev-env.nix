{
  mods.home.dev-env.opts =
    { lib, ... }:
    {
      defaultIdentity = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Enable default username and password for git";
      };
    };
  mods.home.dev-env.conf =
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
      programs.yazi.settings =
        let
          yazi-editor = (
            pkgs.writeShellScriptBin "yazi-open-editor" ''

              # Exit if no files are selected
              if [[ $# -eq 0 ]]; then
                exit 1
              fi

              # 1. Check if we are in the "Explorer" pane of our specific Zellij layout
              if [[ "$ZELLIJ_EXPLORER" != "1" ]]; then
                # Fallback: Execute the system's default editor (or helix if $EDITOR is unset)
                # Using 'exec' replaces the current bash process with the editor
                exec "''${EDITOR:-hx}" "$@"
              fi

              # 2. We are in the layout! Get the current tab ID
              TAB_ID=$(zellij action current-tab-info --json | jq -r '.id')

              # 3. Find the pane ID named "Editor" in this specific tab
              PANE_ID=$(zellij action list-panes --json | jq -r --argjson tab "$TAB_ID" '
                .[] | select((.title == "Editor" or .name == "Editor") and .tab == $tab) | .id
              ' | head -n 1)

              if [[ -z "$PANE_ID" ]]; then
                zellij action write-chars "echo 'No pane named Editor found!'" 
                exit 1
              fi

              # 4. Ensure Helix is in normal mode
              zellij action send-keys --pane-id "$PANE_ID" "ESC"

              # 5. Loop through all files and inject the Helix open commands
              for FILE in "$@"; do
                ESCAPED_FILE=$(printf "%q" "$FILE")
                zellij action write-chars --pane-id "$PANE_ID" ":o $ESCAPED_FILE"
                zellij action send-keys --pane-id "$PANE_ID" "Enter"
              done

              # 6. Focus the editor pane after opening the files
              zellij action focus-pane-id "$PANE_ID"
            ''
          );
        in
        {
          opener = {
            edit = [
              {
                run = "${lib.getExe yazi-editor} \"$@\"";
                block = true;
                desc = "Open in editor";
              }
            ];
          };
          open = {
            prepend_rules = [
              {
                mime = "text/*";
                use = "edit";
              }
            ];
          };
        };
      # Remove after 26.05
      programs.yazi.shellWrapperName = "y";

      home.packages = [
        # VCS tools
        pkgs.lazygit
        pkgs.lazyjj
        pkgs.gh
        # Terminal tools
        pkgs.ripgrep
        pkgs.repgrep
        pkgs.bat
        pkgs.watchman
        pkgs.just
        pkgs.fzf
        # Cloning
        pkgs.rsync
        # Recording terminal
        pkgs.asciinema
      ];
    };
}
