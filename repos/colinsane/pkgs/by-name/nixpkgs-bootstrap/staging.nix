{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "b0b9c2bf297eac4b5e6f4a7f306f802ac0bcf0b3";
  sha256 = "sha256-eku47hJLfOqeXQ4fdsgoE1aQeZbL07cTH7pQTXI8fYs=";
  version = "unstable-2025-11-21";
  branch = "staging";
}
