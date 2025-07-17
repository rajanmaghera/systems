let
  baseConfig = builtins.fromJSON (builtins.readFile ../configuration.json);
in
{
  configIos =
    target:
    let
      devConfig = baseConfig // {
        inherit target;
      };
    in
    {
      configuration = devConfig;
      output = builtins.toJSON devConfig;
    };
}
