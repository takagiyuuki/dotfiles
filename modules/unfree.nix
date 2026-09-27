{
  lib,
  ...
}:
{
  # Allow unfree only for specific packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "terraform"
      "claude-code"
    ];
}
