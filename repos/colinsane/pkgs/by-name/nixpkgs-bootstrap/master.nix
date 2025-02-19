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
  rev = "49bae9aaddd584d28321f729e166903fb81ad23c";
  sha256 = "sha256-mIY+RwUDvtVN1/6g0CbJKqlG3jhwR9ttX1Q3h9C0cw8=";
  version = "0-unstable-2025-02-17";
  branch = "master";
}
