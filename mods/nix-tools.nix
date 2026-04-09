{
  mods.home.nix-tools.conf =
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
        pkgs.nix-fast-build
      ];

      programs.nh.enable = true;

    };
}
