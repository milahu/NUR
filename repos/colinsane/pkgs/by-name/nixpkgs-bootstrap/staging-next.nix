{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "7126324b6bddf0af871b98e63ff7c38e41604f49";
  sha256 = "sha256-xzN3Ya3Pk3oEKgIzQ4QwSs9/VZNGNJLTa9f/dzmmpx8=";
  version = "unstable-2025-11-13";
  branch = "staging-next";
}
