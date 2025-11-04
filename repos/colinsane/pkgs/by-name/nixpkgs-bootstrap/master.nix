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
  rev = "10df7d42b99d9aa19e50c794dde54527bfaa10a9";
  sha256 = "sha256-388MNy/2q3E1TD0wcWAm3+8lKXdG2ZBt/J8F0LWcLwk=";
  version = "unstable-2025-11-03";
  branch = "master";
}
