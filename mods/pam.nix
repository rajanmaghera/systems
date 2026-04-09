{
  # TODO: opts take function params?
  mods.darwin.pam.opts =
    { lib, ... }:
    {
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
  mods.darwin.pam.conf =
    {
      lib,
      pkgs,
      cfg,
      ...
    }:
    {
      my.pam.text = lib.concatLines (
        (lib.optional cfg.reattach "auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so")
        ++ (lib.optional cfg.touchIdAuth "auth       sufficient     pam_tid.so")
      );

      environment.etc."pam.d/sudo_local" = {
        inherit (cfg) text;
      };
    };
}
