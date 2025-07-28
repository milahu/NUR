{
  lib,
  python3Packages,
  fetchFromGitHub,
  autoreconfHook,
  gtk3,
  gst_all_1,
  libwnck,
  upower,
  gwebsockets,
  sugar-toolkit-gtk3,
  glib,
  gobject-introspection,
  intltool,
  pkg-config,
  wrapGAppsHook3,
  gtksourceview,
  libxklavier,
  webkitgtk_4_1,
  nix-update-script,
}:

let
  version = "0.121";

  dependencies = [
    python3Packages.dbus-python
    python3Packages.empy
    python3Packages.pygobject3
    python3Packages.xapian
    gwebsockets
    sugar-toolkit-gtk3
  ];
in

python3Packages.buildPythonPackage {
  pname = "sugar";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "sugarlabs";
    repo = "sugar";
    tag = "v${version}";
    hash = "sha256-BlhihSMoiu84Otkgcv5dAaGLsTxzDNGs3wL1I8PXYeg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    glib # AM_GNU_GLIB_GETTEXT, GLIB_GSETTINGS
    gobject-introspection
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtksourceview
    libxklavier
    webkitgtk_4_1
  ];

  propagatedBuildInputs = [
    gtk3
    gst_all_1.gstreamer
    libwnck
    upower
  ];

  preAutoreconf = ''
    mkdir -p m4
  '';

  preBuild = ''
    cp po/en.po po/ig.po
  '';

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--disable-update-mimedb"
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")

    substituteInPlace $out/bin/sugar --replace-fail "exec python3" "exec ${python3Packages.python.interpreter}"
    wrapGApp $out/bin/sugar --prefix PYTHONPATH : "${python3Packages.makePythonPath dependencies}:$out/${python3Packages.python.sitePackages}"
  '';

  pythonImportsCheck = [
    "jarabe"
    "jarabe.apisocket"
    "jarabe.config"
    "jarabe.testrunner"
    "jarabe.controlpanel"
    "jarabe.controlpanel.cmd"
    "jarabe.controlpanel.gui"
    "jarabe.controlpanel.inlinealert"
    "jarabe.controlpanel.sectionview"
    "jarabe.controlpanel.toolbar"
    "jarabe.desktop"
    "jarabe.desktop.activitieslist"
    "jarabe.desktop.activitychooser"
    "jarabe.desktop.homebackgroundbox"
    "jarabe.desktop.keydialog"
    "jarabe.desktop.networkviews"
    "jarabe.desktop.schoolserver"
    "jarabe.desktop.snowflakelayout"
    "jarabe.desktop.viewcontainer"
    "jarabe.intro"
    "jarabe.intro.agepicker"
    "jarabe.intro.colorpicker"
    "jarabe.intro.genderpicker"
    "jarabe.intro.window"
    "jarabe.journal"
    "jarabe.journal.bundlelauncher"
    "jarabe.journal.detailview"
    "jarabe.journal.expandedentry"
    "jarabe.journal.iconmodel"
    "jarabe.journal.iconview"
    "jarabe.journal.journalactivity"
    "jarabe.journal.journalentrybundle"
    "jarabe.journal.journaltoolbox"
    "jarabe.journal.journalwindow"
    "jarabe.journal.keepicon"
    "jarabe.journal.listmodel"
    "jarabe.journal.listview"
    "jarabe.journal.misc"
    "jarabe.journal.modalalert"
    "jarabe.journal.model"
    "jarabe.journal.objectchooser"
    "jarabe.journal.palettes"
    "jarabe.journal.projectview"
    "jarabe.journal.volumestoolbar"
    "jarabe.model"
    "jarabe.model.adhoc"
    "jarabe.model.brightness"
    "jarabe.model.buddy"
    "jarabe.model.bundleregistry"
    "jarabe.model.desktop"
    "jarabe.model.filetransfer"
    "jarabe.model.friends"
    "jarabe.model.invites"
    "jarabe.model.keyboard"
    "jarabe.model.mimeregistry"
    "jarabe.model.neighborhood"
    "jarabe.model.network"
    "jarabe.model.notifications"
    "jarabe.model.olpcmesh"
    "jarabe.model.screen"
    "jarabe.model.screenshot"
    "jarabe.model.session"
    "jarabe.model.shell"
    "jarabe.model.speech"
    "jarabe.model.telepathyclient"
    "jarabe.model.update"
    "jarabe.model.update"
    "jarabe.model.update.aslo"
    "jarabe.model.update.microformat"
    "jarabe.model.update.updater"
    "jarabe.util"
    "jarabe.util.downloader"
    "jarabe.util.httprange"
    "jarabe.util.normalize"
    "jarabe.util.telepathy"
    "jarabe.util.telepathy"
    "jarabe.util.telepathy.connection_watcher"
    "jarabe.view"
    "jarabe.view.alerts"
    "jarabe.view.cursortracker"
    "jarabe.view.customizebundle"
    "jarabe.view.gesturehandler"
    "jarabe.view.launcher"
    "jarabe.view.palettes"
    "jarabe.view.pulsingicon"
    "jarabe.view.service"
    "jarabe.view.tabbinghandler"
    "jarabe.view.viewhelp"
    "jarabe.view.viewhelp_webkit2"
    "jarabe.view.viewsource"
    "jarabe.webservice"
    "jarabe.webservice.account"
    "jarabe.webservice.accountsmanager"

    # RuntimeError: could not create new GType: jarabe+desktop+grid+Grid (subclass of void)
    # "jarabe.desktop.favoriteslayout"
    # "jarabe.desktop.grid"
    # "jarabe.desktop.homewindow"
    # "jarabe.desktop.transitionbox"

    # ImportError: cannot import name 'BuddyMenu' from partially initialized module 'jarabe.view.buddymenu' (most likely due to a circular import)
    # "jarabe.desktop.favoritesview"
    # "jarabe.desktop.friendview"
    # "jarabe.desktop.groupbox"
    # "jarabe.desktop.homebox"
    # "jarabe.frame"
    # "jarabe.frame.activitiestray"
    # "jarabe.frame.clipboard"
    # "jarabe.frame.clipboardicon"
    # "jarabe.frame.clipboardmenu"
    # "jarabe.frame.clipboardobject"
    # "jarabe.frame.clipboardpanelwindow"
    # "jarabe.frame.clipboardtray"
    # "jarabe.frame.devicestray"
    # "jarabe.frame.eventarea"
    # "jarabe.frame.frame"
    # "jarabe.frame.frameinvoker"
    # "jarabe.frame.framewindow"
    # "jarabe.frame.friendstray"
    # "jarabe.frame.notification"
    # "jarabe.frame.zoomtoolbar"
    # "jarabe.view.buddymenu"

    # ImportError: cannot import name 'BuddyIcon' from partially initialized module 'jarabe.view.buddyicon' (most likely due to a circular import)
    # "jarabe.desktop.viewtoolbar"
    # "jarabe.view.buddyicon"

    # ImportError: cannot import name 'MeshBox' from partially initialized module 'jarabe.desktop.meshbox' (most likely due to a circular import)
    # "jarabe.desktop.meshbox"

    # gi.repository.GLib.GError: g-invoke-error-quark: Could not locate acme_volume_alsa_new: 'acme_volume_alsa_new': <sugar-toolkit-gtk3>/lib/libsugar-eventcontroller.so.0: undefined symbol: acme_volume_alsa_new (1)
    # "jarabe.model.sound"
    # "jarabe.view.keyhandler"
  ];

  passthru = {
    providedSessions = [ "sugar" ];
    updateScript = nix-update-script { extraArgs = [ "--version-regex=v(.*)" ]; };
  };

  meta = {
    description = "Sugar GTK shell";
    homepage = "https://github.com/sugarlabs/sugar";
    changelog = "https://github.com/sugarlabs/sugar/blob/v${version}/NEWS";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
