{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.tailscale;
in {
  options.my.tailscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable configuration as a Tailscale client.";
    };
    authenticationKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Authentication key for Tailscale. If supplied, a oneshot service will be called to authenticate the machine. This only needs to be done once.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tailscale
    ];
    services.tailscale.enable = true;

    systemd.services.tailscale-autoconnect = mkIf (cfg.authenticationKey != null) {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        ${tailscale}/bin/tailscale up -authkey ${cfg.authenticationKey}
      '';
    };
  };
}
