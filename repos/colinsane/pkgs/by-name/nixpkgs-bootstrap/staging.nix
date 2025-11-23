{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "d8e562d572fd29d4a8a35089b66fa41d7c0328cd";
  sha256 = "sha256-jOEadM6sUhsHN6TEh/LiRCHwzt17IOH2ZTlf3WPRvKk=";
  version = "unstable-2025-11-22";
  branch = "staging";
}
