let
  makeSystem = modules: overlayHome: stateVersion: hostName: system: {
    inherit system;
    modules = modules ++ [
      (./. + "/${hostName}")
      (overlayHome (import (./. + "/${hostName}/home.nix")))
      (import ./me.nix {
        inherit system hostName;
      })
      {
        system.stateVersion = stateVersion;
      }
    ];
  };
  configIos = (import ./ios.nix).configIos;
in
{
  nixos =
    {
      modules,
      configNixos,
      overlayHome,
      stateVersion,
    }:
    {
      "sourpi" = configNixos (makeSystem modules overlayHome stateVersion "sourpi" "aarch64-linux");
      "dessert" = configNixos (makeSystem modules overlayHome stateVersion "dessert" "aarch64-linux");
      "pie" = configNixos (makeSystem modules overlayHome stateVersion "pie" "aarch64-linux");
    };

  darwin =
    {
      modules,
      configDarwin,
      overlayHome,
      stateVersion,
    }:
    {
      "fruit" = configDarwin (makeSystem modules overlayHome stateVersion "fruit" "aarch64-darwin");
    };

  ios = {
    "banana" = configIos "banana";
  };
}
