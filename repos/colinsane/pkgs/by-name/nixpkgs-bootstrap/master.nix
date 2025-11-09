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
  rev = "8a0ddfe5e62a2814979672aa1afd54dfb4aa345a";
  sha256 = "sha256-RyQ8FpohhQumkR7+Yoj4FyUyRQ5A0vJnJ2ZUEtYAMUQ=";
  version = "unstable-2025-11-08";
  branch = "master";
}
