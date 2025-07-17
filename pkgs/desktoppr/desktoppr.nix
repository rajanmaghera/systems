{
  stdenv,
  lib,
  fetchzip,
  ...
}:
let
  version = "0.4";
in
stdenv.mkDerivation {
  pname = "desktoppr";
  inherit version;

  src = fetchzip {
    url = "https://github.com/scriptingosx/desktoppr/releases/download/v${version}/desktoppr-${version}.zip";
    sha256 = "sha256-+7bIlltJE0th3cgTxZ2ShRNe6XBgXJBBO57hiMZXOYo=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 $src/desktoppr $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/scriptingosx/desktoppr";
    description = "Simple command line tool to set the desktop picture on macOS";
    license = licenses.asl20;
    platforms = platforms.darwin;
  };
}
