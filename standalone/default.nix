{
  nixpkgs,
  modules,
  configHome,
}:
let
  makeHome =
    username: homeDirectory: system:
    (configHome {
      pkgs = import nixpkgs {
        inherit system;
      };
      modules = [
        {
          home = {
            inherit username homeDirectory;
          };
        }
      ]
      ++ modules;
    });
in
{
  "precision" = makeHome "rajan" "/home/rajan" "x86_64-linux";
}
