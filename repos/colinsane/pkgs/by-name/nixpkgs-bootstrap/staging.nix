{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "61fccdd160ab74223547c9ce9cd4d8ae40962054";
  sha256 = "sha256-qSDF1jTxmIsgSqN2vRZ1VbXnHV8U+q+O/ppdAFLWB7k=";
  version = "unstable-2025-11-23";
  branch = "staging";
}
