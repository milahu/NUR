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
  rev = "66a5440b0386c3e9da77467fb448f78b6e00dbc6";
  sha256 = "sha256-7PUQ7FRDHvce4/lP/3QDV8d1R0XA7ilel6ID+JWDOUM=";
  version = "unstable-2025-11-25";
  branch = "master";
}
