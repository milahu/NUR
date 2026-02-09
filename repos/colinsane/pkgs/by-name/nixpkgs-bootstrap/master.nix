# to fix sha256 (in case the updater glitches):
# - delete `sha256` or set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got: sha256-xyz`
# - past that hash back into the `sha256` field
{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "c6f889da0a7204657a8b77c53ede0ce6fa49c9ed";
  sha256 = "sha256-LxJ7WrPQ0pDyP+KjA3YxWeRXnEXhJARCPnKtLnyAVXE=";
  version = "unstable-2026-02-07";
  branch = "master";
}
