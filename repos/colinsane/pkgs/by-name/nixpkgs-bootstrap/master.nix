# to fix sha256 (in case the updater glitches):
# - set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got:  sha256:xyz`
# - nix hash to-sri sha256:xyz
#   - paste the output as the new `sha256`
{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "72bccb2960235fd31de456566789c324a251f297";
  sha256 = "sha256-8qmLpDUmaiBGLZkFfVyK5/T5fyTXXGdzCRdqAtO0gf4=";
  version = "0-unstable-2025-03-04";
  branch = "master";
}
