{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "928cae63265d8797f0439585a9dc36702cb9234e";
  sha256 = "sha256-XhKGEaqmYu4uzBVwWKZSMYaDDg57vtA4NHI/oGH44X4=";
  version = "unstable-2025-12-18";
  branch = "staging-next";
}
