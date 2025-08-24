{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
  wrapGAppsHook3,
  sugar-toolkit-gtk3,
  vte,
}:

let
  version = "46.3";
in

python3Packages.buildPythonApplication {
  pname = "sugar-terminal-activity";
  inherit version;
  format = "other";

  src = fetchFromGitHub {
    owner = "sugarlabs";
    repo = "terminal-activity";
    tag = "v${version}";
    hash = "sha256-Gh1y1ApmLrYFcadnBmg9k/eugf3/2zrEqcGgE8LENFg=";
  };

  nativeBuildInputs = [
    gettext
    wrapGAppsHook3
  ];

  dependencies = [ sugar-toolkit-gtk3 ];

  # Cursed, don't do this.
  # TODO: Replace with a patch.
  postPatch = ''
    sed -i terminal.py -e '27i from gi.repository import GIRepository; GIRepository.Repository.prepend_search_path("${vte}/lib/girepository-1.0")'
  '';

  installPhase = ''
    export XDG_DATA_HOME="$out/share"

    python3 setup.py install --prefix $out
  '';

  meta = {
    description = "A traditional linux terminal activity for the Sugar learning environment";
    homepage = "https://github.com/sugarlabs/terminal-activity";
    changelog = "https://github.com/sugarlabs/terminal-activity/blob/v${version}/NEWS";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
  };
}
