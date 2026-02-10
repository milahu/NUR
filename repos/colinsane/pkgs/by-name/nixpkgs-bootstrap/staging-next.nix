{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "25c40f7c47275cc585ec84abc12eb51fc9b4c120";
  sha256 = "sha256-z1NCqyAYMkha0CAXz606udWvKKbyRgPkVYdS98a4q1k=";
  version = "unstable-2026-02-08";
  branch = "staging-next";
}
