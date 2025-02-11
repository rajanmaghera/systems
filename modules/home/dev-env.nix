{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.dev-env;
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
      ignores = [
        ".direnv"
        ".envrc"
        ".DS_Store"
      ];
      extraConfig = {
        core.fsmonitor = true;
      };
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

    home.packages = with pkgs;
      [
        (git-branchless.overrideAttrs
          {
            doCheck = false;
          })
        git-absorb
        lazygit
        nodejs
        yarn
        glab
        gh
        with-pkg
        watchman
        rustup
        ocaml
        opam
        ocamlPackages.ocaml-lsp
        ocamlPackages.ocamlformat
        neovim
      ]
      ++ lib.optionals stdenv.isDarwin [
        libiconv
        darwin.apple_sdk.frameworks.Security
        darwin.apple_sdk.frameworks.SystemConfiguration
        darwin.apple_sdk.frameworks.CoreServices
        darwin.apple_sdk.frameworks.CoreFoundation
        pkg-config
        openssl
      ];
  };
}
