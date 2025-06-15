{ stdenv
, pkgs
, lib
, ...
}:
pkgs.misskey.overrideAttrs (
  final: prev: rec {
    pname = "misskey";
    version = "2025.6.1-rc.0";
    src = pkgs.fetchFromGitHub {
      owner = "misskey-dev";
      repo = "misskey";
      rev = version;
      hash = "sha256-eMPTLciofuiK2PHY9Cn6SdwlwBKnfB29YQXgMOJHqyo=";
      fetchSubmodules = true;
    };
    patches = [ ];
    pnpmDeps = pkgs.pnpm_9.fetchDeps {
      inherit pname version src;
      hash = "sha256-T8LwpEjeWNmkIo3Dn1BCFHBsTzA/Dt6/pk/NMtvT0N4=";
    };
  }
)
