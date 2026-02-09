{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "aba80eebd4fe8f6d5f6cb31c55277a7e1fc3204f";
  sha256 = "sha256-XLSbzke+jZ/PU+HC1yeqBVpzUEPDMZ1TrCEAp5OzdIk=";
  version = "unstable-2026-02-04";
  branch = "staging";
}
