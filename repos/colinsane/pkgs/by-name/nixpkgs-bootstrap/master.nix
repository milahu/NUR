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
  rev = "6621eb0885c64fc8c068a526c9579fa4c28cc6bf";
  sha256 = "sha256-UmCxazoUXrTt0Ow6qQwD8UlZf9sTylFy9blTGBrG8Ys=";
  version = "unstable-2025-11-21";
  branch = "master";
}
