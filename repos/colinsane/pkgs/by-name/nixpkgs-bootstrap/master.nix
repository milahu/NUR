# to fix sha256 (in case the updater glitches):
# - set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got:  sha256:xyz`
# - nix hash to-sri sha256:xyz
#   - paste the output as the new `sha256`
{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "2d9e4457f8e83120c9fdf6f1707ed0bc603e5ac9";
  sha256 = "sha256-ZF3YOjq+vTcH51S+qWa1oGA9FgmdJ67nTNPG2OIlXDc=";
  version = "0-unstable-2025-03-08";
  branch = "master";
}
