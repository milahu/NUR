{
  lib,
  python3Packages,
  fetchFromGitHub,
  autoreconfHook,
  gobject-introspection,
  wrapGAppsHook3,
  sugar-toolkit-gtk3,
  coreutils,
  nix-update-script,
}:

let
  version = "0.121";
in

python3Packages.buildPythonPackage {
  pname = "sugar-datastore";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "sugarlabs";
    repo = "sugar-datastore";
    tag = "v${version}";
    hash = "sha256-S1LoQH4CmenbGXGiqO5QR138KM6XIHKTeNG09PwGtwY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    wrapGAppsHook3
  ];

  dependencies = [
    python3Packages.dbus-python
    python3Packages.pygobject3
    python3Packages.xapian
    sugar-toolkit-gtk3
  ];

  dontWrapGApps = true;

  postPatch = ''
    substituteInPlace src/carquinyol/datastore.py --replace-fail "/usr/bin/du" "${lib.getExe' coreutils "du"}"
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  pythonImportsCheck = [
    "carquinyol"
    "carquinyol.datastore"
    "carquinyol.filestore"
    "carquinyol.indexstore"
    "carquinyol.layoutmanager"
    "carquinyol.metadatastore"
    "carquinyol.migration"
    "carquinyol.optimizer"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sugar datastore service";
    homepage = "https://github.com/sugarlabs/sugar-datastore";
    changelog = "https://github.com/sugarlabs/sugar-datastore/blob/v${version}/NEWS";
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.linux;
  };
}
