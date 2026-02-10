# to fix sha256 (in case the updater glitches):
# - delete `sha256` or set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got: sha256-xyz`
# - past that hash back into the `sha256` field
{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e437aeac42c5ad96faab8458823f47070ebdcba6";
  sha256 = "sha256-5rWcChv2VopLf4AmLfXi3OSEfjzKF8fz9VLE5JEo8ws=";
  version = "unstable-2026-02-08";
  branch = "master";
}
