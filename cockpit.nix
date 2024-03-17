{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.serve.cockpit;

  sv = {
    port = 9192;
    ws = true;
    category = "Admin";
    fullName = "Cockpit";
    abbr = "PT";
  };
in {
  options.serve.cockpit = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    serve.register.ckpt = mkIf cfg.enable sv;

    services.cockpit = mkIf cfg.enable {
      enable = true;
      port = sv.port;
      settings = {
        WebService.Origins = "${config.serve.details.ckpt.url} ${config.serve.details.ckpt.wsUrl}";
        WebService.ProtocolHeader = "X-Forwarded-Proto";
        WebService.AllowUnencrypted = true;
      };
    };
  };
}
