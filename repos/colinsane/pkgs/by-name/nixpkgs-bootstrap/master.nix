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
  rev = "da5cc354cf31d8514d763c39f5a685da3fe1eb3e";
  sha256 = "sha256-tJ8RIG8JiMV9NGYWegYw1bEO/Ja09mH1y7RhuviEN78=";
  version = "unstable-2025-12-18";
  branch = "master";
}
