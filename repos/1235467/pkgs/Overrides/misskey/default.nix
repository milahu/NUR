{ stdenv
, pkgs
, lib
, ...
}:
pkgs.misskey.overrideAttrs (
  final: prev: rec {
    pname = "misskey";
    version = "2025.4.1";
    src = pkgs.fetchFromGitHub {
      owner = "misskey-dev";
      repo = "misskey";
      rev = version;
      hash = "sha256-qe/MxoUBAEyVSdlv/iz3QwdBQ/1Nu6aRI7Di35IVgME=";
      fetchSubmodules = true;
    };
    patches = [ ];
    pnpmDeps = pkgs.pnpm_9.fetchDeps {
      inherit pname version src;
      hash = "sha256-X63X1buukL3eZPAe7EGSz3vxFYfbfFKSiICze2fYbDQ=";
    };
  }
)
