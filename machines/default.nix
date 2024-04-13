let
  makeSystem = modules: overlayHome: hostName: system: {
    inherit system;
    modules =
      modules
      ++ [
        (./. + "/${hostName}")
        (overlayHome (import (./. + "/${hostName}/home.nix")))
        (import ./me.nix {
          inherit system hostName;
        })
      ];
  };
in {
  nixos = {
    modules,
    configNixos,
    overlayHome,
  }: {
    "sourpi" = configNixos (makeSystem modules overlayHome "sourpi" "aarch64-linux");
    "dessert" = configNixos (makeSystem modules overlayHome "dessert" "aarch64-linux");
  };

  darwin = {
    modules,
    configDarwin,
    overlayHome,
  }: {
    "fruit" = configDarwin (makeSystem modules overlayHome "fruit" "aarch64-darwin");
  };
}
