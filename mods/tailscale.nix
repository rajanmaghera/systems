{
  mods.nixos.tailscale.opts =
    { lib, ... }:
    {
      authKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
    };
  mods.nixos.tailscale.conf =
    {
      cfg,
      ...
    }:
    {
      services.tailscale.enable = true;
      services.tailscale.authKeyFile = cfg.authKeyFile;
      services.tailscale.openFirewall = true;
    };
}
