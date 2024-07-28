{
  imessage-ruby,
  writeShellScriptBin,
  ...
}:
writeShellScriptBin "nix-ios" ''
  OUTPUT_CONFIG=$(nix eval .#iosConfigurations.$1.output | sed 's@\\@@g' | sed -e 's/^"//' -e 's/"$//')
  echo "$OUTPUT_CONFIG" > ~/Pictures/ios_config.json
  ${./message} banana ~/Pictures/ios_config.json
''
