{
  mods.darwin.linux-builder.conf =
    {
      ...
    }:
    {
      nix.linux-builder = {
        enable = true;
        ephemeral = true;
        maxJobs = 6;
        config = {
          virtualisation = {
            cores = 6;
            darwin-builder = {
              diskSize = 30 * 1024;
              memorySize = 6 * 1024;
            };
          };
        };
      };
    };
}
