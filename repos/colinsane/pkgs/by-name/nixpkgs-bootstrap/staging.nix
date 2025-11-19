{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "8a6eb85e1d4741ae020d02f9918216393db362bd";
  sha256 = "sha256-NRePqEjW1c+UKrouu1+C2xURkuZKlEm1EaaJgftuLPk=";
  version = "unstable-2025-11-17";
  branch = "staging";
}
