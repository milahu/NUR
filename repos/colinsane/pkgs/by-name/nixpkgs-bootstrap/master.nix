# to fix sha256 (in case the updater glitches):
# - delete `sha256` or set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got: sha256-xyz`
# - past that hash back into the `sha256` field
#
# if that fails, then:
# - set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got:  sha256:xyz`
# - nix hash to-sri sha256:xyz
#   - paste the output as the new `sha256`
{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "fb1a49e59c86a94cfa058daabb18e580a600189e";
  sha256 = "sha256-cu2ha51VICdbWsiyPqswGAz5V3hdEO9CSoXwWa9OVko=";
  version = "unstable-2025-11-10";
  branch = "master";
}
