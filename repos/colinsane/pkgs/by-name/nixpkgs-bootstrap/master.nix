{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "f2866842c201654ca0e4c620ca5a76ce146f74b1";
  sha256 = "sha256-nDPWYGk5dsIV+Q1QYHcxGhkQ5t5wTAHC48xHbr3fLDU=";
  version = "0-unstable-2024-12-05";
  branch = "master";
}
