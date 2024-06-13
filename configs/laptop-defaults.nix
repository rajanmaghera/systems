{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.laptop-defaults;
in {
  options.my.laptop-defaults = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable default configuration options for devices with laptop-like features";
    };

    sound = mkOption {
      type = types.bool;
      default = true;
      description = "Enable sound support";
    };

    touchpad = mkOption {
      type = types.bool;
      default = true;
      description = "Force enable touchpad support";
    };
  };

  config = mkIf cfg.enable {
    sound.enable = mkIf cfg.sound true;
    hardware.pulseaudio.enable = mkIf cfg.sound true;

    services.xserver.libinput.enable = mkIf cfg.touchpad true;
  };
}
