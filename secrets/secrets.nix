let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajan@fruit"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGWI7xEZ1TeqmHkIusuwREMEZdo2kY48sEBsKIHVyoC sourpi"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBR1uxDllS0fbZCkUebMlTrnvQCroyhrvZfWNVD/5ysQ root@pie"
  ];
  manifest = import ./manifest.nix;
  secretsAttrs = builtins.listToAttrs (builtins.map (x: {
      name = "${x.name}.age";
      value = {
        publicKeys = keys;
      };
    })
    manifest);
in
  secretsAttrs
