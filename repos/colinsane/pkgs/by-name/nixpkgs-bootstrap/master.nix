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
  rev = "5db39d669a21ca7f0e76c295e7664b9d938b7042";
  sha256 = "sha256-SUZZMAn19X3Ym6lVb18LoXhCS2yicrRr83si5VyJDS0=";
  version = "0-unstable-2025-02-28";
  branch = "master";
}
