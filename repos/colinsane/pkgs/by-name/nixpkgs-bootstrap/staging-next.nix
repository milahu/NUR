{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "a2302e778cebe7a1fd615ecd4072aa6448a588a1";
  sha256 = "sha256-F94x6W85A7dsXT9R4Lx4KbLzDAE515GWMvNjE2aqs2w=";
  version = "unstable-2025-12-24";
  branch = "staging-next";
}
