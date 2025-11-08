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
  rev = "86f72e2fdf3871cf1051014902a4c2b3cb1cac1c";
  sha256 = "sha256-mlt6ZJYAocpx5dxstLDPqFSUY5LDeKKuBY5m5cT+Qe4=";
  version = "unstable-2025-11-07";
  branch = "master";
}
