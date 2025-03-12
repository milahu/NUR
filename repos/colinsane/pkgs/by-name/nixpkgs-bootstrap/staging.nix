{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "3e526dc6a531f23fc4021389406758bfc8fb9e3a";
  sha256 = "sha256-3CHa38sqMhZFrHoivyICKKyC6GKbyFOzu2sc0Dk2xyw=";
  version = "0-unstable-2025-03-11";
  branch = "staging";
}
