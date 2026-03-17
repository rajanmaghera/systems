{
  mods.nixos.my.docker =
    { ... }:
    {
      virtualisation.docker.enable = true;
    };
}
