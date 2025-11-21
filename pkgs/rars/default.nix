{
  stdenv,
  lib,
  writeText,
  fetchurl,
  jre_minimal,
  makeDesktopItem,
  ...
}:
let
  versionMajor = "1";
  versionMinor = "5";
  jre = jre_minimal.override {
    modules = [
      "java.prefs"
      "java.desktop"
    ];
  };
in
stdenv.mkDerivation {
  pname = "rars";
  version = "${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "https://github.com/TheThirdOne/rars/releases/download/v${versionMajor}.${versionMinor}/rars${versionMajor}_${versionMinor}.jar";
    sha256 = "sha256-w75gfARfR46Up6qng1GYL0u8ENfpD3xHhl/yp9lEcUE=";
  };

  buildInputs = [ jre ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/rars.jar
    cat > $out/bin/rars <<EOF
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar $out/bin/rars.jar "\$@"
    EOF
    chmod +x $out/bin/rars

  '';

  meta = with lib; {
    homepage = "https://github.com/TheThirdOne/rars";
    description = "RARS is the RISC-V Assembler and Runtime Simulator";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
