{
  lib,
  fetchFromGitHub,
  buildGoModule,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "telemikiya";
  version = "0-unstable-2025-02-22";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "TeleMikiya";
    rev = "62d949c18847cb3a71d04b0e84cbf7e91baeb52e";
    hash = "sha256-7YMY/uAxP7vQs8UPiNTn/21MGtz3QUMgpv9v71ycDgE=";
  };

  vendorHash = "sha256-87zQuJyQVuCHvUg4x+OuF+S+Lhv9zmjQUEDiqXBhn9Y=";

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    mainProgram = "telemikiya";
    description = "Hybrid message search tool for Telegram";
    homepage = "https://github.com/XYenon/TeleMikiya";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ xyenon ];
  };
}
