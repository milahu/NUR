{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "4274b3d7a19e529f020fa313cfd664030076b892";
  sha256 = "sha256-3bf1BaBzzpEisFR1+zSvOOuwU9zOIWqKs31GCQx5JLI=";
  version = "unstable-2025-11-19";
  branch = "staging-next";
}
