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
  rev = "5f0c96fbe532b4d05f67ccec82de2bc9ea0afb6d";
  sha256 = "sha256-4cBbDgOgtb2D0/L2RaomF7ReHuuR4C4RXObuABQjDN4=";
  version = "unstable-2025-11-26";
  branch = "master";
}
