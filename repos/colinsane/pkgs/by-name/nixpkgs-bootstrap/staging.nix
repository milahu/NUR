{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "71a34279d5b529f98e203f47548822b297faf21b";
  sha256 = "sha256-O4qM+2ByNbWTb8XQ3CCP+11Du7YG9rMQ0VyinkwHQu0=";
  version = "unstable-2026-02-08";
  branch = "staging";
}
