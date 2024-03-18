{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.lab.cockpit;

  sv = {
    port = 9192;
    ws = true;
    category = "Admin";
    fullName = "Cockpit";
    abbr = "PT";
  };
in {
  options.lab.cockpit = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    lab.register.ckpt = mkIf cfg.enable sv;

    services.cockpit = mkIf cfg.enable {
      enable = true;
      port = sv.port;
      settings = {
        WebService.Origins = "${config.lab.details.ckpt.url} ${config.lab.details.ckpt.wsUrl}";
        WebService.ProtocolHeader = "X-Forwarded-Proto";
        WebService.AllowUnencrypted = true;
      };
    };
  };
}
