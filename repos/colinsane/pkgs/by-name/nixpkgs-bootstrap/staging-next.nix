{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "027a39aec9661213b1ff8425041b621aa4f3574a";
  sha256 = "sha256-MX0oSKKG2TK0tipYXa01udooKUzbbYh7YhhlPXVnxZc=";
  version = "unstable-2025-11-21";
  branch = "staging-next";
}
