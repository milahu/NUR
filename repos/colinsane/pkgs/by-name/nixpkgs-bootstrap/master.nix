# to fix sha256 (in case the updater glitches):
# - set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got:  sha256:xyz`
# - nix hash to-sri sha256:xyz
#   - paste the output as the new `sha256`
{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "40911acf7dd8f9483b3192837d0045f68773192a";
  sha256 = "sha256-JBnOQ/SLzMcfMFF2iK6k1QOW28mokQRAq2XCSdmb3AE=";
  version = "0-unstable-2025-02-25";
  branch = "master";
}
