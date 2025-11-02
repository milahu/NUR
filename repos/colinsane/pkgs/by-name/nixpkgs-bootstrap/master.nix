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
  rev = "1e7e16c24c686fd501fcca2fecefca818bf02695";
  sha256 = "sha256-4IVAEcBeaINebolPe08jAfbn5FDBk8gltO5VVeuTfnk=";
  version = "unstable-2025-11-01";
  branch = "master";
}
