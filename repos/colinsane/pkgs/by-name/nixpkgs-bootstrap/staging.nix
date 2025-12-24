{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e83c3ab55f62e1cfd1463ca950ea51c579eb0605";
  sha256 = "sha256-KNiukY46kWUb2x61GlQW0ZRaybgMkkK8ReMAgVH9TCI=";
  version = "unstable-2025-12-23";
  branch = "staging";
}
