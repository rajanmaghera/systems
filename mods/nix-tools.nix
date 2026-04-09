{
  mods.home.my.nix-tools =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.nix-tree
        pkgs.vulnix
        pkgs.deploy-rs
        pkgs.nix-search-cli
        pkgs.hydra-check
      ];

      programs.nh.enable = true;

    };
}
