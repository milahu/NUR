{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "d6e484dfe1022a95b0750364cf5bea90188aef09";
  sha256 = "sha256-26Zo23b69Z1VCvsQ2mA4wOlC5qnDTQDas3jigJHFAxU=";
  version = "unstable-2025-12-20";
  branch = "staging-next";
}
