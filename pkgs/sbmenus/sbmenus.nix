{
  stdenv,
  darwin,
  ...
}:
stdenv.mkDerivation {
  pname = "sbmenus";
  version = "0.1";

  src = ./.;

  #   phases = ["build" "install"];

  buildInputs = [
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.SkyLight
  ];

  buildPhase = ''
    $CC -std=c99 -O3 -F/System/Library/PrivateFrameworks/ -framework Carbon -framework SkyLight sbmenus.c -o sbmenus
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp sbmenus "$out/bin/sbmenus"
  '';
}