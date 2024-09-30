{
  stdenv,
  clang,
  fetchFromGitHub,
  gcc,
  readline,
  lua5_4,
}: let
  lua = lua5_4;
in
  stdenv.mkDerivation {
    pname = "SBarLua";
    version = "unstable-2024-08-12";

    src = fetchFromGitHub {
      owner = "FelixKratz";
      repo = "SbarLua";
      rev = "437bd2031da38ccda75827cb7548e7baa4aa9978";
      hash = "sha256-C2tg1mypz/CdUmRJ4vloPckYfZrwHxc4v8hsEow4RZs=";
    };

    nativeBuildInputs = [
      clang
      gcc
    ];

    buildInputs = [readline];

    installPhase = ''
      mkdir -p $out/lib/lua/${lua.luaversion}/
      cp -r bin/* "$out/lib/lua/${lua.luaversion}/"
    '';
  }
