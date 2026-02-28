{
  crane,
  home-manager,
}:
final: prev: {
  my-cli = (import ./my) crane prev;
  rars_1_5 = prev.callPackage ./rars { version = "1.5"; };
  rars_1_6 = prev.callPackage ./rars { version = "1.6"; };
  rust-shell = prev.callPackage ./rust-shell { };
  llvm-shell = prev.callPackage ./llvm-shell { };
  cuda-shell = prev.callPackage ./cuda-shell { };
  sbarlua = prev.callPackage ./sbarlua { };
  sbmenus = prev.callPackage ./sbmenus { };
  switch-mode = prev.callPackage ./switch-mode { };
  home-manager = home-manager.packages.${prev.stdenv.hostPlatform.system}.home-manager;
  my-emacs = prev.callPackage ./my-emacs { };
  my-tex = prev.callPackage ./my-tex { };
}
