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
  rev = "c9132ccc15a9a32ebda9f923fa7f35410487a152";
  sha256 = "sha256-53MM0ChOezVOL0PfczvENHcxUKxZfiEIS8hqQfZ+/kw=";
  version = "unstable-2025-11-17";
  branch = "master";
}
