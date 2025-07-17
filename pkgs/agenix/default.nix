{ agenix, ... }:
final: prev: {
  agenixFlake = agenix.packages.${prev.system}.default;
}
