{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "476a8a9af32b94b6b43e7e17231ef566ae61ae0f";
  sha256 = "sha256-q8aNISLX+sotNnVgacRAtQ/zJYKYsouV0efJbo2w/qg=";
  version = "0-unstable-2025-03-04";
  branch = "staging";
}
