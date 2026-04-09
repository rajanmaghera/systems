{
  mods.nixos.laptop-defaults.conf =
    { ... }:
    {
      services.libinput.enable = true;
    };
}
