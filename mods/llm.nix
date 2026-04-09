{
  mods.home.llm.conf =
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
