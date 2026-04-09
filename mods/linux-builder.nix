{
  mods.darwin.linux-builder.conf =
    {
      ...
    }:
    {
      nix.linux-builder = {
        enable = true;
        config = {
          virtualisation = {
            darwin-builder = {
              diskSize = 200 * 1024;
              memorySize = 8 * 1024;
            };
            cores = 6;
          };
        };
      };
    };
}
