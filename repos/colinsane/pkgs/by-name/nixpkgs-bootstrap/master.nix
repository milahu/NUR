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
  rev = "88ab3a8fe4d557791ffad2325ab656fe2a4a1441";
  sha256 = "sha256-jk+rUDkuzom5cuPw6e4TsrKUiwc1Zul9+PF0iopshDc=";
  version = "unstable-2025-12-23";
  branch = "master";
}
