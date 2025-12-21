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
  rev = "ced5dadad58e9a709789f45c4be817a7d25397bb";
  sha256 = "sha256-pbpuvMO5KR26wK4LZJgLseZJyvuk69oSyXIGPx6q7Po=";
  version = "unstable-2025-12-20";
  branch = "master";
}
