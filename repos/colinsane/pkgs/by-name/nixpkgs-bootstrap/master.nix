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
  rev = "baaf26b170f7257a26688fe5ed8baa27cf16f742";
  sha256 = "sha256-+cYNfBN7u9a0576yBCYkJhXK5C5IZDBmfysvARJAqEs=";
  version = "unstable-2025-11-19";
  branch = "master";
}
