{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "39279939adf98df0bb548ec23420e9bea650e5dc";
  sha256 = "sha256-aC0vGtIA9Tdx4LsriRKgThnFQ+W/z1WXV+aTLQTURq0=";
  version = "0-unstable-2025-03-07";
  branch = "staging-next";
}
