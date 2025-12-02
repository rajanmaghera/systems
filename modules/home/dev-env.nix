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
      ];
      settings = {
        user.name = mkIf cfg.defaultIdentity "Rajan Maghera";
        user.email = mkIf cfg.defaultIdentity "maghera@cs.toronto.edu";
        core.fsmonitor = true;
        rebase.updateRefs = true;
        merge.conflictstyle = "diff3";
      };
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = mkIf cfg.defaultIdentity "maghera@cs.toronto.edu";
          name = mkIf cfg.defaultIdentity "Rajan Maghera";
        };
      };
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.tmux = {
      enable = true;
      extraConfig = ''
        set -sg escape-time 0
        set -g status-left-length 20
      '';
    };

    programs.helix = {
      enable = true;
      settings = {
        editor.line-number = "relative";
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
    };

    programs.nnn = {
      enable = true;
    };

    fonts.fontconfig.enable = true;

    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraConfig = ''

        local wezterm = require 'wezterm'
        local config = wezterm.config_builder()

        config.font_size = 12
        config.font = wezterm.font 'Fragment Mono'
        config.enable_tab_bar = false
        config.default_prog = { '${pkgs.zsh}/bin/zsh', '-l' }
        config.set_environment_variables = {
          ZELLIJ_AUTO_ATTACH= "true",
        }

        config.keys = {
          { key = 'Enter', mods = 'ALT', action = wezterm.action.DisableDefaultAssignment },
        }

        return config
      '';

    };

    home.packages =
      with pkgs;
      [
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
        nixfmt-rfc-style
        typescript
        typescript-language-server
        yazi
      ]
      ++ lib.optionals stdenv.isDarwin [
        libiconv
        pkg-config
        openssl
      ];
  };
}
