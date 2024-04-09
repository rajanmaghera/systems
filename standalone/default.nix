{
  nixpkgs,
  modules,
  configHome,
}: let
  makeHome = username: homeDirectory: system: (
    configHome {
      pkgs = import nixpkgs {
        inherit system;
      };
      modules =
        [
          {
            home = {
              inherit username homeDirectory;
            };
          }
        ]
        ++ modules;
    }
  );
in {
  "work" =
    makeHome "rajan" "/home/rajan" "x86_64-linux";

  "work-server" =
    makeHome "rmaghera" "/home/rmaghera" "x86_64-linux";
}
