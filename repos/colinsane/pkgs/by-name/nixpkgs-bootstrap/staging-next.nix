{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "3b4b17f3e50d73d0fc9b13a674797f9c2323c800";
  sha256 = "sha256-lzAJogOvjTLIFEUEs59YIeBkckeO5dO8O9mAYH1FZiI=";
  version = "unstable-2025-11-26";
  branch = "staging-next";
}
