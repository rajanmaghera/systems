inputs: [
  (import ./caddy)
  (import ./rars)
  (import ./cudatoolkit-pin)
  ((import ./my) inputs)
  (import ./desktoppr)
  (import ./nix-ios)
  (import ./with-pkg)
  (import ./rust-shell)
  (import ./custom-nerdfonts)
  (import ./custom-google-fonts)
  (import ./cuda-shell)
  ((import ./agenix) inputs)
  ((import ./vscode-extensions) inputs)
  ((import ./rpi) inputs)
]
