{ stdenv, fetchFromGitHub }:
  stdenv.mkDerivation rec {
    pname = "catppuccin-macchiato";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/src/catppuccin-macchiato $out/share/sddm/themes/catpuccin-macchiato
    '';
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
      sha256 = "sha256-95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
    };
}
