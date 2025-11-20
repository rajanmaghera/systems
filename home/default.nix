stateVersion:
let
  c = import ./config.nix stateVersion;
in
{
  config = c;
  system =
    { config, ... }:
    {
      home-manager.users."${config.my.profile.user}" = c;
    };
  overlayHome =
    cfg:
    { config, ... }:
    {
      home-manager.users."${config.my.profile.user}" = cfg;
    };
}
