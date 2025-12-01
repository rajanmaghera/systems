{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.my.aerospace;
in
{
  options.my.aerospace = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services.aerospace = {
      enable = true;
      settings = {
        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };
        mode = config.my.defaults.shortcutMap.aerospace;

        ## AUTOMATIONS

        on-window-detected = [
          # Force iCloud Passwords prompt to be floating
          {
            "if".window-title-regex-substring = "iCloud Passwords";
            check-further-callbacks = true;
            run = [ "layout floating" ];
          }
        ];
      };
    };
  };
}
