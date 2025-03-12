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
  rev = "4028c38d07192e816424732781c371c8b9c649b7";
  sha256 = "sha256-CF77jrTyG3dqcJtO3pmOamIvJsS66+pPhDPsZUAiHmM=";
  version = "0-unstable-2025-03-11";
  branch = "master";
}
