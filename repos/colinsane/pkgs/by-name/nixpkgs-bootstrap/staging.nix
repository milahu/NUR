{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "d9ea73fab625fb1f00acc75b22315a0ba49436a4";
  sha256 = "sha256-uqFCZRSB1ZRKVqG9k6jh1jsvFGGCteTc6zBNzH0YHAU=";
  version = "0-unstable-2025-02-16";
  branch = "staging";
}
