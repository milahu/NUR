{ lib
, buildPythonApplication
, fetchFromGitHub
, dbus-next
, grim
, swayidle
}:

buildPythonApplication {
  pname = "upwork-wayland";
  version = "unstable-2022-06-17";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "MarSoft";
    repo = "upwork-wayland";
    rev = "4921e208087c0da108ec1b594894f6087d8b8421";
    hash = "sha256-KZ8TwAEAHuf4YoGPjnh0rK5cDFrGqzBRCi0JNCPg3SA=";
  };

  propagatedBuildInputs = [
    dbus-next
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 screenshot_adapter.py $out/bin/upwork-wayland

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--prefix PYTHONPATH : $PYTHONPATH"
    "--prefix PATH : ${lib.makeBinPath [ grim swayidle ]}"
  ];

  meta = with lib; {
    description = "Bridge between Gnome Screenshot protocol and Sway WM";
    homepage = "https://github.com/MarSoft/upwork-wayland";
    license = licenses.free;
    platforms = platforms.linux;
    mainProgram = "upwork-wayland";
    maintainers = with maintainers; [ wolfangaukang ];
  };

}
