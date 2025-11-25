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
  rev = "cfe2c7d5b5d3032862254e68c37a6576b633d632";
  sha256 = "sha256-g4MKqsIRy5yJwEsI+fYODqLUnAqIY4kZai0nldAP6EM=";
  version = "unstable-2025-11-24";
  branch = "master";
}
