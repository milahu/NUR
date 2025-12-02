{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "f232a7f7bc05c608ac8a16e6de4372375868a97f";
  sha256 = "sha256-8GCsNlydEuo/KBOeepiDaTbIgdwyspEbFmklAp8lUQ8=";
  version = "unstable-2025-12-01";
  branch = "staging";
}
