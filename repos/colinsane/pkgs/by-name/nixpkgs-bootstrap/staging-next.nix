{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "5f9439fc05c9469d5256a0545505fe4e9149490c";
  sha256 = "sha256-8yVp5dfuM7DwBld9ozayxo/MjChmRV0VODXeaa1N42w=";
  version = "0-unstable-2024-12-05";
  branch = "staging-next";
}
