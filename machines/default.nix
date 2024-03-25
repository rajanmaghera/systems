let
  makeSystem = modules: hostName: system: {
    inherit system;
    modules =
      modules
      ++ [
        (./. + "/${hostName}")
        (import ./me.nix {
          inherit system hostName;
        })
      ];
  };
in {
  nixos = {
    modules,
    configNixos,
  }: {
    "sourpi" = configNixos (makeSystem modules "sourpi" "aarch64-linux");
  };

  darwin = {
    modules,
    configDarwin,
  }: {
    "fruit" = configDarwin (makeSystem modules "fruit" "aarch64-darwin");
  };
}
