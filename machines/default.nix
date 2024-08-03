let
  makeSystem = modules: hostName: system: {
    inherit system;
    modules =
      modules
      ++ [
        (./. + "/${hostName}")
      ];
  };
  configIos = (import ./ios.nix).configIos;
in {
  nixos = {
    modules,
    configNixos,
  }: {
    "sourpi" = configNixos (makeSystem modules "sourpi" "aarch64-linux");
    "dessert" = configNixos (makeSystem modules "dessert" "aarch64-linux");
  };

  darwin = {
    modules,
    configDarwin,
  }: {
    "fruit" = configDarwin (makeSystem modules "fruit" "aarch64-darwin");
  };

  ios = {
    "banana" = configIos "banana";
  };
}
