{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
  ...
}@args:
mkNixpkgs ({
  rev = "29dcbf482396b9e5bdf1ec92973a8451e0aaa1d5";
  sha256 = "sha256-ps1xz98RAUqrT+V7GFpzf/uHaoh9o5ZoOpE7SnSB6sY=";
  version = "0-unstable-2025-02-28";
  branch = "staging";
} // args)
