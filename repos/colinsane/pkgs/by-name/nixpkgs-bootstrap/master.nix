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
  rev = "d2312fff025b9ded48bcecd2406c1c266666de91";
  sha256 = "sha256-S5xl/MJNS71mXnWB5wyGWtH58GeZDRdwfL9qjTfxkIw=";
  version = "unstable-2025-11-18";
  branch = "master";
}
