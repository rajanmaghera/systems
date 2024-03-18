final: prev: let
  fetchXCaddy = prev.callPackage ./fetchXCaddy.nix {};
  caddyWith = prev.callPackage ./caddyWith.nix {inherit fetchXCaddy;};
in {
  caddy-extended = prev.callPackage ./caddy-extended.nix {inherit caddyWith;};
}
