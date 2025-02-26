{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "d486cb02afd23aea34d6311cc590c822f238063c";
  sha256 = "sha256-bFQCXdZVnUU0vnwEXG/GPxtsGVH+puEzMOrPsMMqHyc=";
  version = "0-unstable-2025-02-25";
  branch = "staging";
}
