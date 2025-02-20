{
  lib,
  fetchFromGitHub,
  buildGoModule,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "telemikiya";
  version = "0-unstable-2025-02-19";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "TeleMikiya";
    rev = "c5ef8d33785f4aa129193e8b2abd1117f7ae095e";
    hash = "sha256-67FUnYm9GST3qYwEWbtaZFMWY14+E+E+2QYfiRsOWCw=";
  };

  vendorHash = "sha256-EqqgOVHixfS+H6nPJH4H28W/oyiNML0fhyY0GmvEmbc=";

  subPackages = [ "." ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Hybrid message search tool for Telegram";
    homepage = "https://github.com/XYenon/TeleMikiya";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ xyenon ];
  };
}
