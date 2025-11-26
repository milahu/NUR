{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "d489d1d67792e72617cddffee6b96bee084a2a6b";
  sha256 = "sha256-Q6XxhsKO7cwgoTgd928Ta8nRSeB90t/VV78LbdezYjU=";
  version = "unstable-2025-11-25";
  branch = "staging";
}
