# to fix sha256 (in case the updater glitches):
# - set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got:  sha256:xyz`
# - nix hash to-sri sha256:xyz
#   - paste the output as the new `sha256`
{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "2aa37bb93fb33769ee887e399313a21b52dce710";
  sha256 = "sha256-/ZmWq+GY7R8IL6CyykV9eKtgxb0kVpAnykYvEv9XQAE=";
  version = "0-unstable-2025-02-26";
  branch = "master";
}
