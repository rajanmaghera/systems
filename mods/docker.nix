{
  mods.nixos.docker.conf =
    { ... }:
    {
      virtualisation.docker.enable = true;
    };
}
