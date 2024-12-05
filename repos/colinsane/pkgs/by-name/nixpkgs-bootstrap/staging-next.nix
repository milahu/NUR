{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "6bd69b5616dbe66af8e5dd2259d520157d1ae3d4";
  sha256 = "sha256-hddpR8T8aDx6GdsyEW8OUkhU6NkRsVS6KJ5MHAqf3Fc=";
  version = "0-unstable-2024-12-04";
  branch = "staging-next";
}
