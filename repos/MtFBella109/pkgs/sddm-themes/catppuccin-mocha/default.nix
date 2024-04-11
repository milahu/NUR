{ stdenv, fetchFromGitHub }:
  stdenv.mkDerivation rec {
    pname = "catppuccin-mocha";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/src/catppuccin-mocha $out/share/sddm/themes/catppuccin-mocha
    '';
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
      sha256 = "sha256-95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
    };
}
