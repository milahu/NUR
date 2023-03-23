{ lib, stdenv, fetchzip, gettext }:

stdenv.mkDerivation rec {
  pname = "cockpit-podman";
  version = "48";

  src = fetchzip {
    url = "https://github.com/cockpit-project/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-yLdudVUXL4+u6ZVzv931eNFBY4lFcGdhjeGOIQcS274=";
  };

  nativeBuildInputs = [
    gettext
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/share $out/share
    touch dist/manifest.json
    echo "yo"
  '';

  dontBuild = true;

  meta = with lib; {
    description = "Cockpit UI for virtual machines";
    license = licenses.lgpl21;
    homepage = "https://github.com/cockpit-project/cockpit-machines";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    broken = true;
  };
}
