{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "b36dbc87167907c7de2ec4649b15f445b08a40d9";
  sha256 = "sha256-Q/GUbE97euzgyvA1r0JmUq9kgqWMxLWXqGaLZGydKZU=";
  version = "unstable-2025-12-28";
  branch = "staging";
}
