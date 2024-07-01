let
  manifest = import ./manifest.nix;
  secretsAttrs = builtins.listToAttrs (builtins.map (x: {
      name = x.name;
      value = {
        file = ./. + "${x.name}.age";
      };
    })
    manifest);
in {
  age.secrets = secretsAttrs;
}
