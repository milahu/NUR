{ lib
, fetchFromGitHub
, stdenv
, python3
, wayland
}:

stdenv.mkDerivation rec {
  pname = "wayland-debug";
  version = "0-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "wayland-debug";
    rev = "06182981d39ab39ed48d91666565767d48dd1007";
    hash = "sha256-R1cUnzabxyoSj28SXXEJW5crfpNsPcwuAo8UK/4/VKg=";
  };

  postPatch = ''
    patchShebangs *
    substituteInPlace main.py \
      --replace-fail '/usr/bin/python3' '${python3.interpreter}'
  '';

  installPhase = ''
    mkdir -p $out/lib/dist
    mv * $out/lib/dist
    mkdir -p $out/bin
    ln -s $out/lib/dist/main.py $out/bin/wayland-debug
    mkdir -p $out/lib/dist/resources/wayland/build/src
    ln -s ${wayland}/lib/* $out/lib/dist/resources/wayland/build/src/
  '';

  meta = {
    description = "Command line tool to help debug Wayland clients and servers";
    homepage = "https://github.com/wmww/wayland-debug";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    mainProgram = "wayland-debug";
  };
}

