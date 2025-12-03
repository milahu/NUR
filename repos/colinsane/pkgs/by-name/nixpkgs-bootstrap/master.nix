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
  rev = "4bb63da52aca2d83660fe6db06b551fadaac47ec";
  sha256 = "sha256-jHWOPQI7bF48n1xnaKOolEOuLaRYsmKk5SoB/CukT9U=";
  version = "unstable-2025-12-02";
  branch = "master";
}
