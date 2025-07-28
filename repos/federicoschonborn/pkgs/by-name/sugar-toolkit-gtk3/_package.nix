{
  lib,
  python3Packages,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  gobject-introspection,
  intltool,
  pkg-config,
  alsa-lib,
  gtk3,
  xorg,
  gdk-pixbuf,
  librsvg,
  telepathy-glib,
  webkitgtk_4_1,
  nix-update-script,
}:

let
  version = "0.121";
in

python3Packages.buildPythonPackage {
  pname = "sugar-toolkit-gtk3";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "sugarlabs";
    repo = "sugar-toolkit-gtk3";
    tag = "v${version}";
    hash = "sha256-iwxA2Hw4YEpBJFimBwUbePuFy6DE7ia86zKhDzqWAHU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    glib # glib-genmarshal, glib-mkenums
    gobject-introspection
    intltool
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    gtk3
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXfixes
    xorg.libXi
    webkitgtk_4_1
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    librsvg
    telepathy-glib
  ];

  dependencies = [
    python3Packages.dbus-python
    python3Packages.decorator
    python3Packages.pycairo
    python3Packages.pygobject3
    python3Packages.python-dateutil
    python3Packages.six
  ];

  # Fixes "undefined symbol: acme_volume_alsa_new"
  # https://sugar-devel.sugarlabs.narkive.com/TpoBknpF/bug-1240354-soas-live-x86-64-20150706-does-not-login-from-live-system-user
  # https://src.fedoraproject.org/rpms/sugar-toolkit-gtk3/blob/2373acd9e5fb72a41b9ed3f71faeee7f35390bec/f/sugar-toolkit-gtk3.spec#_1
  # https://gitlab.archlinux.org/archlinux/packaging/packages/sugar-toolkit-gtk3/-/blob/14d68793543091c9ceed856be39c530ceb42fe8e/PKGBUILD#L24-25
  hardeningDisable = [ "bindnow" ];

  pythonImportsCheck = [
    "sugar3"
    "sugar3.activity"
    "sugar3.activity.activity"
    "sugar3.activity.activityfactory"
    "sugar3.activity.activityhandle"
    "sugar3.activity.activityinstance"
    "sugar3.activity.activityservice"
    "sugar3.activity.bundlebuilder"
    "sugar3.activity.i18n"
    "sugar3.activity.webactivity"
    "sugar3.activity.widgets"
    "sugar3.bundle"
    "sugar3.bundle.activitybundle"
    "sugar3.bundle.bundle"
    "sugar3.bundle.bundleversion"
    "sugar3.bundle.contentbundle"
    "sugar3.bundle.helpers"
    "sugar3.datastore"
    "sugar3.datastore.datastore"
    "sugar3.dispatch"
    "sugar3.dispatch.dispatcher"
    "sugar3.dispatch.saferef"
    "sugar3.graphics"
    "sugar3.graphics.alert"
    "sugar3.graphics.animator"
    "sugar3.graphics.colorbutton"
    "sugar3.graphics.combobox"
    "sugar3.graphics.iconentry"
    "sugar3.graphics.icon"
    "sugar3.graphics.menuitem"
    "sugar3.graphics.notebook"
    "sugar3.graphics.objectchooser"
    "sugar3.graphics.palettegroup"
    "sugar3.graphics.palettemenu"
    "sugar3.graphics.palette"
    "sugar3.graphics.palettewindow"
    "sugar3.graphics.panel"
    "sugar3.graphics.progressicon"
    "sugar3.graphics.radiopalette"
    "sugar3.graphics.radiotoolbutton"
    "sugar3.graphics.scrollingdetector"
    "sugar3.graphics.style"
    "sugar3.graphics.toggletoolbutton"
    "sugar3.graphics.toolbarbox"
    "sugar3.graphics.toolbox"
    "sugar3.graphics.toolbutton"
    "sugar3.graphics.toolcombobox"
    "sugar3.graphics.tray"
    "sugar3.graphics.window"
    "sugar3.graphics.xocolor"
    "sugar3.presence"
    "sugar3.presence.activity"
    "sugar3.presence.buddy"
    "sugar3.presence.connectionmanager"
    "sugar3.presence.presenceservice"
    "sugar3.presence.sugartubeconn"
    "sugar3.presence.tubeconn"
    "sugar3.config"
    "sugar3.env"
    "sugar3.logger"
    "sugar3.mime"
    "sugar3.network"
    "sugar3.power"
    "sugar3.profile"
    "sugar3.speech"
    "sugar3.util"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sugar Learning Environment, Activity Toolkit, GTK 3";
    homepage = "https://github.com/sugarlabs/sugar-toolkit-gtk3";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
  };
}
