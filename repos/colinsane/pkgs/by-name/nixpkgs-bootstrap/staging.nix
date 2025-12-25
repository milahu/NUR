{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "00dcef87da2b29298628d4f6c9f8a52179210d9c";
  sha256 = "sha256-hlaRTSvJZl6TUNpmPifTRoZEcQpCcHd6fZnysFtuenI=";
  version = "unstable-2025-12-24";
  branch = "staging";
}
