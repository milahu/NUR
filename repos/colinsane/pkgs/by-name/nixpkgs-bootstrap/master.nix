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
  rev = "c61c2ea23951221f44a26c5579789a4aacb0cf38";
  sha256 = "sha256-glA/LO9CzgCnTQCn67Uwcr+XJ9nMol3kQauKCpwitpA=";
  version = "unstable-2025-12-24";
  branch = "master";
}
