{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "c32b0ea6c9dc5a4d399335864a1b8e3b9be2e0d6";
  sha256 = "sha256-wgvA65Qd8HHuOl4sq7PtmdainJfAieAM3V2b1gAYp28=";
  version = "0-unstable-2024-12-03";
  branch = "staging";
}
