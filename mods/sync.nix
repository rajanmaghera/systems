{

  mods.home.sync.opts =
    { lib, ... }:
    {
      publicGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allow access to syncthing outside localhost";
      };
    };

  mods.home.sync.conf =
    { lib, cfg, ... }:
    {
      services.syncthing = {
        enable = true;
        guiAddress = lib.mkIf cfg.publicGui "0.0.0.0:8384";
      };
    };

}
