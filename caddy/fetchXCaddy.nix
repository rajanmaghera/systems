{
  lib,
  cacert,
  caddy,
  go,
  stdenv,
  xcaddy,
}: {
  plugins ? [],
  hash ? null,
}:
stdenv.mkDerivation {
  pname = "caddy-using-xcaddy-${xcaddy.version}";
  inherit (caddy) version;

  dontUnpack = true;
  dontFixup = true;

  nativeBuildInputs = [cacert go];

  configurePhase = ''
    export GOCACHE="$TMPDIR/go-cache"
    export GOPATH="$TMPDIR/go"
    export XCADDY_SKIP_BUILD=1
  '';

  buildPhase = ''
    ${lib.getExe xcaddy} build "${caddy.src.rev}" \
      ${lib.concatMapStringsSep " \\\n  " (plugin: "--with ${plugin}") plugins}
    cd buildenv*
    go mod vendor
  '';

  installPhase = ''
    cp -r --reflink=auto . "$out"
  '';

  outputHash = hash;
  outputHashMode = "recursive";
}
