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
  rev = "fc28f964f57b5821eea552d3460adddfaf5c812b";
  sha256 = "sha256-Emh/AIs7HM6zPLml/DomljkT7O/dkoybU6YJp+OOFTA=";
  version = "unstable-2025-12-15";
  branch = "master";
}
