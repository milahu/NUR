{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "b6bd36b868d1b890219c2ce1078cca1a724e2c49";
  sha256 = "sha256-huwT6xOVJDvFTP490LTfaajmRIoUaBAHJb3sahHgCQ0=";
  version = "0-unstable-2024-12-04";
  branch = "master";
}
