{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "1b13ad424b8556579590aef792394cbf12f3e75d";
  sha256 = "sha256-zAHoRmb9ucJG90A3jEnxmG9ihpy6u2tzIn5UBHDTznM=";
  version = "0-unstable-2025-02-25";
  branch = "staging-next";
}
