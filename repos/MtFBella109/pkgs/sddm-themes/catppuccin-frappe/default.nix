{ stdenv, fetchFromGitHub }:
  stdenv.mkDerivation rec {
    pname = "catppuccin-latte";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/src/catppuccin-latte $out/share/sddm/themes/catpuccin-latte
    '';
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
      sha256 = "sha256-95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
    };
}
