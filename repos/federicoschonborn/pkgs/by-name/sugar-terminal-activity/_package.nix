{
  lib,
  python3,
  fetchFromGitHub,
  gettext,
  wrapGAppsHook3,
  sugar-toolkit-gtk3,
  vte,
}:

let
  version = "47";
in

python3.pkgs.buildPythonApplication {
  pname = "sugar-terminal-activity";
  inherit version;
  format = "other";

  src = fetchFromGitHub {
    owner = "sugarlabs";
    repo = "terminal-activity";
    tag = "v${version}";
    hash = "sha256-WxEhtC6LKM1pH2fJpusUk9QKSTHiCk4476ZZZb3ZFSo=";
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
