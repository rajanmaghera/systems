{
  configNixos,
  modules,
}: let
  makeNixos = hostname: system: mod: (configNixos {
    inherit system;
    modules =
      modules
      ++ [
        mod
        ./me.nix
        {
          networking.hostName = hostname;
        }
      ];
  });
in {
  nixos = {
    "dessert" = (
      makeNixos "dessert" "aarch64-linux" ./dessert
    );
  };
}
