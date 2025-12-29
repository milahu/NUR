{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "1282ddcbbfda4aeb266bc4e389e5f9ceba1cc55b";
  sha256 = "sha256-J4AMGjLZhGobduZRdimShSRNONhju+L1XsJkbejtMBQ=";
  version = "unstable-2025-12-28";
  branch = "staging-next";
}
