{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "d3cf03ff89df6dffb2efa3022a993d6e753eff99";
  sha256 = "sha256-0cgcPVOtYpTeJlMd5XV/7dc9+iCWv69v5K08Vth4Asg=";
  version = "unstable-2025-11-26";
  branch = "staging";
}
