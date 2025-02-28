{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "98be054e5b8a4cdebd5649221ab51f089530d1a6";
  sha256 = "sha256-FIBdw9D1wA4soXIfgynCA5wZTp29wOvcEh4XMbXcDks=";
  version = "0-unstable-2025-02-26";
  branch = "staging-next";
}
