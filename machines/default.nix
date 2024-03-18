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
    "sourpi" = (
      makeNixos "sourpi" "aarch64-linux" ./sourpi
    );
  };
}
