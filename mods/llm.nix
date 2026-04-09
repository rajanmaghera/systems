{
  mods.home.my.llm =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.ollama
      ];
    };
}
