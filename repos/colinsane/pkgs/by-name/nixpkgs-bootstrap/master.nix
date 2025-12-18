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
  rev = "23e551007038b23552c4430d8d137f99530f2c6c";
  sha256 = "sha256-yQPhsvGc2cV8a4tXahX3eaeDqkRec6eR6CU+Pkwsy3A=";
  version = "unstable-2025-12-17";
  branch = "master";
}
