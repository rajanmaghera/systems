{
  mods.nixos.my.laptop-defaults =
    { ... }:
    {
      services.libinput.enable = true;
    };
}
