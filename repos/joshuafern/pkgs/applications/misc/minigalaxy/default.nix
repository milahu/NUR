{ buildPythonApplication, lib, fetchFromGitHub, glib-networking
, gobjectIntrospection, gtk3, setuptools, gettext, wrapGAppsHook, docutils
, pygobject3, requests, steam-run, webkitgtk }:

buildPythonApplication rec {
  pname = "minigalaxy";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "sharkwouter";
    repo = pname;
    rev = version;
    sha256 = "0m8r5gb1k9cjji64rswximl49klychxzbzxhmfrpjq57c0zg5vs8";
  };

  doCheck = false;

  buildInputs = [ glib-networking gobjectIntrospection gtk3 setuptools ];
  nativeBuildInputs = [ gettext wrapGAppsHook ];
  propagatedBuildInputs = [ docutils pygobject3 requests steam-run webkitgtk ];

  # Prevent homeless error
  preCheck = "export HOME=$PWD";

  # Run games using the Steam Runtime by using steam-run in the wrapper
  postFixup = ''
    sed -e 's/exec -a "$0"/exec -a "$0" steam-run/' -i $out/bin/minigalaxy
  '';

  meta = with lib; {
    broken = true; # Not actually, just saving my ci time
    homepage = "https://sharkwouter.github.io/minigalaxy/";
    downloadPage = "https://github.com/sharkwouter/minigalaxy/releases";
    description = "A simple GOG client for Linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [ joshuafern ];
    platforms = platforms.linux;
  };
}