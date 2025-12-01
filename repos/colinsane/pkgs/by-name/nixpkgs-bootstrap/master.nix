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
  rev = "79a7cb8ed501d2b9cfe2dd5c0b20127e61919b92";
  sha256 = "sha256-brWXm43xzFu1m+wf9mooQAB9Yt1G6S5rNDcvvNwQXaE=";
  version = "unstable-2025-11-30";
  branch = "master";
}
