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
  rev = "fbe3ece68d9126ef1fedd60c15c361d27ce7b312";
  sha256 = "sha256-C4C66CbAsngetlqTp52W/ycvfOYGv1z9AuP98tg0TwQ=";
  version = "unstable-2025-12-28";
  branch = "master";
}
