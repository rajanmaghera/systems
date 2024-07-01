let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+";
  manifest = import ./manifest.nix;
  secretsAttrs = builtins.listToAttrs (builtins.map (x: {
      name = "${x.name}.age";
      value = {
        publicKeys = [key];
      };
    })
    manifest);
in
  secretsAttrs
