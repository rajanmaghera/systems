{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.security.pam;
in
{
  options = {
    my.security.pam = {
      enable = lib.mkEnableOption "managing {file}`/etc/pam.d/sudo_local` with nix-darwin" // {
        default = false;
        example = true;
      };

      text = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Contents of {file}`/etc/pam.d/sudo_local`
        '';
      };

      touchIdAuth = lib.mkEnableOption "" // {
        default = true;
        description = ''
          Whether to enable Touch ID with sudo.

          This will also allow your Apple Watch to be used for sudo. If this doesn't work,
          you can go into `System Settings > Touch ID & Password` and toggle the switch for
          your Apple Watch.
        '';
      };

      reattach = lib.mkEnableOption "" // {
        default = true;
        description = ''
          Whether to enable reattaching a program to the user's bootstrap session.

          This fixes Touch ID for sudo not working inside tmux and screen.

          This allows programs like tmux and screen that run in the background to
          survive across user sessions to work with PAM services that are tied to the
          bootstrap session.
        '';
      };
    };
  };

  config = {
    my.security.pam.text = lib.concatLines (
      (lib.optional cfg.reattach "auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so")
      ++ (lib.optional cfg.touchIdAuth "auth       sufficient     pam_tid.so")
    );

    environment.etc."pam.d/sudo_local" = {
      inherit (cfg) enable text;
    };
  };
}
