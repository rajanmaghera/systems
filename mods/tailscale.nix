{
  mods.nixos.tailscale.opts =
    { lib, ... }:
    {
      authenticationKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Authentication key for Tailscale. If supplied, a oneshot service will be called to authenticate the machine. This only needs to be done once.";
        default = null;
      };
    };
  mods.nixos.tailscale.conf =
    {
      lib,
      cfg,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.tailscale
      ];
      services.tailscale.enable = true;

      systemd.services.tailscale-autoconnect = lib.mkIf (cfg.authenticationKey != null) {
        description = "Automatic connection to Tailscale";

        # make sure tailscale is running before trying to connect to tailscale
        after = [
          "network-pre.target"
          "tailscale.service"
        ];
        wants = [
          "network-pre.target"
          "tailscale.service"
        ];
        wantedBy = [ "multi-user.target" ];

        # set this service as a oneshot job
        serviceConfig.Type = "oneshot";

        # have the job run this shell script
        script = ''
          # wait for tailscaled to settle
          sleep 2

          # check if we are already authenticated to tailscale
          status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # otherwise authenticate with tailscale
          ${pkgs.tailscale}/bin/tailscale up -authkey ${cfg.authenticationKey}
        '';
      };
    };
}
