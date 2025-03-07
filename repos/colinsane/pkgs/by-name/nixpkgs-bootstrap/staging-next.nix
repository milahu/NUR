{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "d0cbf7399d9b39bd4a4f57093c7893ca3f1fc51a";
  sha256 = "sha256-tjQR7jtV2Q8Lflrz7l9Vtoz+aejZg1L62IFU4XEW5aE=";
  version = "0-unstable-2025-03-06";
  branch = "staging-next";
}
