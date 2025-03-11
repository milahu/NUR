# to fix sha256 (in case the updater glitches):
# - set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got:  sha256:xyz`
# - nix hash to-sri sha256:xyz
#   - paste the output as the new `sha256`
{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "91f4fb0a75bcb7e557e19d1640152a33ea5f5b20";
  sha256 = "sha256-dc3Qp41UiyEhGUEd13B6h8hhKuaebup9vgq5GFa+qPg=";
  version = "0-unstable-2025-03-10";
  branch = "master";
}
