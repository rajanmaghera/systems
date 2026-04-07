{ lb, ... }:
{
  ops.home.my.sync.publicGui = lb.opt.bool true "Allow access to syncthing outside localhost";

  mods.home.my.sync =
    { lib, cfg, ... }:
    {
      services.syncthing = {
        enable = true;
        guiAddress = lib.mkIf cfg.publicGui "0.0.0.0:8384";
      };

    };
}
