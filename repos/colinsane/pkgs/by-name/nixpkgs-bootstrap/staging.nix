{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "9c7c6cc7fff9afa12734594b5c363f5645220862";
  sha256 = "sha256-Gnusu/7leN/ZCFhkbpfsBwp9MTNPWZssFDqwyXmjghg=";
  version = "unstable-2025-10-31";
  branch = "staging";
}
