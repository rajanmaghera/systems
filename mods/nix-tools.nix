{
  mods.home.my.nix-tools =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        nix-tree
        vulnix
      ];

      programs.nh.enable = true;

    };
}
