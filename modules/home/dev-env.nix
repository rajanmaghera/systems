{ lib, config, pkgs, ... }:
with lib;
let cfg = config.my.dev-env;
in {
  options.my.dev-env = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    defaultIdentity = mkOption {
      type = types.bool;
      default = true;
      description = mkDoc ''
        Enable your default git identity using your UAlberta email.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = mkIf cfg.defaultIdentity "Rajan Maghera";
      userEmail = mkIf cfg.defaultIdentity "rmaghera@ualberta.ca";
      ignores = [ ".direnv" ".envrc" ".DS_Store" ];
      extraConfig = { core.fsmonitor = true; rebase.updateRefs = true; };
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = mkIf cfg.defaultIdentity "rmaghera@ualberta.ca";
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
        set -g status-left-length 20
      '';
    };

    programs.helix = {
      enable = true;
      settings = {
        theme = "darcula-solid";
        editor.line-number = "relative";
        editor.file-picker.hidden = false;
      };
      languages.language-server = {
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
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
          };
          roots = ["Cargo.toml" "Cargo.lock"];
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

    home.packages = with pkgs;
      [
        (git-branchless.overrideAttrs { doCheck = false; })
        git-absorb
        lazygit
        nodejs
        yarn
        glab
        gh
        ripgrep
        with-pkg
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
      ] ++ lib.optionals stdenv.isDarwin [
        libiconv
        pkg-config
        openssl
      ];
  };
}
