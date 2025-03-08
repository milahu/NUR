{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "fa22578dc252539c2f2533a2e442b61adb65cbca";
  sha256 = "sha256-9Qf6E6c4ur0CBlz7mElmQ3VJY+VtnrKHFPpVRisA0vI=";
  version = "0-unstable-2025-03-07";
  branch = "staging";
}
