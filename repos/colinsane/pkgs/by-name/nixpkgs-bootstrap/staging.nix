{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "9c4e8387239a0a4047f862210b24987fe6323c73";
  sha256 = "sha256-Pd154QGoMWxyqPSPmcbtVQgalc+Mir1RYPWe7xQr1eI=";
  version = "unstable-2025-11-08";
  branch = "staging";
}
