{ stdenv
, lib
, fetchzip
, alsa-lib
, autoPatchelfHook
, copyDesktopItems
, dbus-glib
, ffmpeg
, gtk2-x11
, withGTK3 ? true
, gtk3
, libglvnd
, libXt
, libpulseaudio
, makeDesktopItem
, wrapGAppsHook
, testers
}:

stdenv.mkDerivation rec {
  pname = "basilisk-bin";
  version = "20240203205403";

  src = fetchzip {
    urls = [
      "https://archive.basilisk-browser.org/2024.02.03/linux/x86_64/gtk3/basilisk-${version}.linux-x86_64-gtk${if withGTK3 then "3" else "2"}.tar.xz"
    ];
    hash = if withGTK3 then
      "sha256-QtTgQRDXCU4xxUysgN2PTEHBx1F7B/DlXBVQuqv6U68="
    else
      "";
  };

  preferLocalBuild = true;

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    dbus-glib
    gtk2-x11
    libXt
    stdenv.cc.cc.lib
  ] ++ lib.optionals withGTK3 [
    gtk3
  ];

  desktopItems = [(makeDesktopItem rec {
    name = "basilisk-bin";
    desktopName = "Basilisk Web Browser";
    comment = "Browse the World Wide Web";
    keywords = [
      "Internet"
      "WWW"
      "Browser"
      "Web"
      "Explorer"
    ];
    exec = "basilisk %u";
    terminal = false;
    type = "Application";
    icon = "basilisk";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/xml"
      "application/rss+xml"
      "application/rdf+xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/chrome"
      "video/webm"
      "application/x-xpinstall"
    ];
    startupNotify = true;
    startupWMClass = "Basilisk";
    extraConfig = {
      X-MultipleArgs = "false";
    };
    actions = {
      "NewTab" = {
        name = "Open new tab";
        exec = "basilisk -new-tab https://start.palemoon.org";
      };
      "NewWindow" = {
        name = "Open new window";
        exec = "basilisk -new-window";
      };
      "NewPrivateWindow" = {
        name = "Open new private window";
        exec = "basilisk -private-window";
      };
      "ProfileManager" = {
        name = "Open the Profile Manager";
        exec = "basilisk --ProfileManager";
      };
    };
  })];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/basilisk}
    cp -R * $out/lib/basilisk/

    ln -s $out/{lib/basilisk,bin}/basilisk

    for iconpath in chrome/icons/default/default{16,32,48} icons/mozicon128; do
      n=''${iconpath//[^0-9]/}
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      ln -s $out/lib/basilisk/browser/"$iconpath".png $out/share/icons/hicolor/$size/apps/basilisk.png
    done

    # Disable built-in updater
    # https://forum.palemoon.org/viewtopic.php?f=5&t=25073&p=197771#p197747
    # > Please do not take this as permission to change, remove, or alter any other preferences as that is forbidden
    # > without express permission according to the Pale Moon Redistribution License.
    # > We are allowing this one and **ONLY** one exception in order to properly facilitate [package manager] repacks.
    install -Dm644 ${./zz-disableUpdater.js} $out/lib/basilisk/browser/defaults/preferences/zz-disableUpdates.js

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    # Make optional dependencies available
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        ffmpeg
        libglvnd
        libpulseaudio
      ]}"
    )
    wrapGApp $out/lib/basilisk/basilisk
  '';

  meta = with lib; {
    homepage = "https://www.palemoon.org/";
    description = "An Open Source, Goanna-based web browser focusing on efficiency and customization";
    longDescription = ''
      Pale Moon is an Open Source, Goanna-based web browser focusing on
      efficiency and customization.

      Pale Moon offers you a browsing experience in a browser completely built
      from its own, independently developed source that has been forked off from
      Firefox/Mozilla code a number of years ago, with carefully selected
      features and optimizations to improve the browser's stability and user
      experience, while offering full customization and a growing collection of
      extensions and themes to make the browser truly your own.
    '';
    changelog = "https://repo.palemoon.org/MoonchildProductions/Pale-Moon/releases/tag/${version}_Release";
    license = [
      licenses.mpl20
      {
        fullName = "Pale Moon Redistribution License";
        url = "https://www.palemoon.org/redist.shtml";
        # TODO free, redistributable? Has strict limitations on what modifications may be done & shipped by packagers
      }
    ];
    maintainers = with maintainers; [ AndersonTorres OPNA2608 ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "basilisk";
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [];
  };
}
