{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.dev-env;
in
{
  options.my.dev-env = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    defaultIdentity = mkOption {
      type = types.bool;
      default = true;
      description = mkDoc ''
        Enable your default git identity using your DCS email.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      ignores = [
        ".direnv"
        ".envrc"
        ".DS_Store"
        "justfile"
      ];
      settings = {
        user.name = mkIf cfg.defaultIdentity "Rajan Maghera";
        user.email = mkIf cfg.defaultIdentity "maghera@cs.toronto.edu";
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
        theme = mkIf config.my.defaults.theme.enable "base16_terminal";
      };
      languages.language-server = {
        texlab = {
          command = "${pkgs.texlab}/bin/texlab";
          config = {
            auxDirectory = "output";
            chktex = {
              onOpenAndSave = true;
              onEdit = true;
            };
            build = {
              forwardSearchAfter = true;
              onSave = true;
              executable = "${pkgs.tectonic}/bin/tectonic";
              args = [
                "-X"
                "compile"
                "%f"
                "--synctex"
                "--keep-logs"
                "--keep-intermediates"
                "--outdir=output"
              ];
            };
            forwardSearch = {
              executable = "${pkgs.zathura}/bin/zathura";
              args = [
                "--synctex-forward"
                "%l:1:%f"
                "%p"
              ];
              onSave = false;
            };
          };
        };
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
          config = {
            python.analysis.venvPath = ".";
            python.analysis.venv = ".venv";
            python.analysis.lint = true;
            python.analysis.inlayHint.enable = true;
            python.analysis.autoSearchPaths = true;
            python.analysis.diagnosticMode = "workspace";
            python.analysis.useLibraryCodeForType = true;
            python.analysis.logLevel = "Error";
            python.analysis.typeCheckingMode = "off";
            python.analysis.autoImoprtCompletion = true;
            python.analysis.reportOptionalSubscript = false;
            python.analysis.reportOptionalMemberAccess = false;
          };
        };
        ruff = {
          command = "${pkgs.ruff}/bin/ruff";
          args = [
            "server"
            "-q"
            "--preview"
          ];
        };
        rust-analyzer = {
          command = "rust-analyzer";
          config = {
            inlayHints.bindingModeHints.enable = false;
            inlayHints.closingBraceHints.minLines = 10;
            inlayHints.closureReturnTypeHints.enable = "with_block";
            inlayHints.discriminantHints.enable = "fieldless";
            inlayHints.lifetimeElisionHints.enable = "skip_trivial";
            inlayHints.typeHints.hideClosureInitialization = false;
          };
        };
      };
      languages.language = [
        {
          name = "latex";
          language-servers = [
            "texlab"
            "ltex"
          ];
          indent = {
            tab-width = 4;
            unit = " ";
          };

        }
        {
          name = "python";
          scope = "source.python";
          injection-regex = "python";
          file-types = [
            "py"
            "pyi"
            "py3"
            "pyw"
            "ptl"
            "rpy"
            "cpy"
            "ipy"
            "pyt"
            { glob = ".python_history"; }
            { glob = ".pythonstartup"; }
            { glob = ".pythonrc"; }
            { glob = "SConstruct"; }
            { glob = "SConscript"; }
          ];
          shebangs = [ "python" ];
          roots = [
            "pyproject.toml"
            "setup.py"
            "poetry.lock"
            "pyrightconfig.json"
            "requirements.txt"
            ".venv/"
          ];
          comment-token = "#";
          language-servers = [ "pyright" ];
          indent = {
            tab-width = 4;
            unit = "    ";
          };
          auto-format = true;
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "-"
            ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
          };
          roots = [
            "Cargo.toml"
            "Cargo.lock"
          ];
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "\"" = "\"";
            "`" = "`";
          };
        }
      ];
    };

    programs.zellij = {
      enable = true;
      settings = {
        default_shell = "${pkgs.zsh}/bin/zsh";
        show_startup_tips = false;
        session_serialization = false;
        theme = mkIf config.my.defaults.theme.enable "ansi";
      };
    };

    fonts.fontconfig.enable = true;

    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraConfig = ''
        local wezterm = require 'wezterm'
        local config = wezterm.config_builder()

        config.font_size = 14
        config.font = wezterm.font '${config.my.defaults.theme.fontFamily}'
        config.enable_tab_bar = false
        config.default_prog = { '${pkgs.zsh}/bin/zsh', '-l' }
        config.set_environment_variables = {
          ZELLIJ_AUTO_ATTACH = "true",
        }
        config.window_close_confirmation = "NeverPrompt"
        config.keys = {
          { key = 'Enter', mods = 'ALT', action = wezterm.action.DisableDefaultAssignment },
        }

        return config
      '';

    };

    programs.ghostty =

      let
        makeTheme = colors: {

          background = colors.base00;
          foreground = colors.base05;
          cursor-color = colors.base05;
          selection-background = colors.base02;
          selection-foreground = colors.base05;

          palette = with colors.withHashtag; [
            "0=${base00}"
            "1=${base08}"
            "2=${base0B}"
            "3=${base0A}"
            "4=${base0D}"
            "5=${base0E}"
            "6=${base0C}"
            "7=${base05}"
            "8=${base03}"
            "9=${base08}"
            "10=${base0B}"
            "11=${base0A}"
            "12=${base0D}"
            "13=${base0E}"
            "14=${base0C}"
            "15=${base07}"
          ];
        };
      in

      {
        enable = true;
        package = pkgs.ghostty-bin;

        themes.my-light = mkIf config.my.defaults.theme.enable (
          makeTheme config.my.defaults.theme.base16LightColors
        );
        themes.my-dark = mkIf config.my.defaults.theme.enable (
          makeTheme config.my.defaults.theme.base16DarkColors
        );

        settings = {
          command = "/usr/bin/env ZELLIJ_AUTO_ATTACH=\"true\" ${pkgs.zsh}/bin/zsh -l";
          confirm-close-surface = false;
          quit-after-last-window-closed = true;
          macos-option-as-alt = true;
          font-family = config.my.defaults.theme.fontFamily;
          theme = mkIf config.my.defaults.theme.enable "light:my-light,dark:my-dark";
        };
      };

    home.packages =
      with pkgs;
      [
        deploy-rs
        emacsPackages.mu4e
        my-emacs
        ispell
        nerd-fonts.fira-code
        nerd-fonts.cousine
        nerd-fonts.iosevka
        nerd-fonts.jetbrains-mono
        nerd-fonts.geist-mono
        nerd-fonts.im-writing
        fragment-mono
        (git-branchless.overrideAttrs { doCheck = false; })
        git-absorb
        lazygit
        nodejs
        yarn
        glab
        nixd
        gh
        ripgrep
        watchman
        rustup
        ocaml
        opam
        ocamlPackages.ocaml-lsp
        ocamlPackages.ocamlformat
        neovim
        nixfmt
        typescript
        typescript-language-server
        yazi
        nix-search-cli
        just
      ]
      ++ lib.optionals stdenv.isDarwin [
        libiconv
        pkg-config
        openssl
      ];
  };
}
