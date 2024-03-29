{ stdenv
, lib
, fetchzip
, alsa-lib
, autoPatchelfHook
, copyDesktopItems
, dbus-glib
, ffmpeg
, gtk2-x11
, gtk3
, libXt
, libpulseaudio
, makeDesktopItem
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "avx-palemoon-bin";
  version = "32.3.0";

  src = fetchzip {
    urls = [
      "ftp://ftp2.palemoon.org/avx/linux/palemoon-${version}.linux-x86_64-avx_gtk3.tar.xz"
    ];
    hash = 
      "sha256-4c0N0yVY4uLacC1GbD0uy87FcwnLvRkeIlYaljntvMQ=";
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
    gtk3
  ];

  desktopItems = [(makeDesktopItem rec {
    name = pname;
    desktopName = "Pale Moon Web Browser";
    comment = "Browse the World Wide Web";
    keywords = [
      "Internet"
      "WWW"
      "Browser"
      "Web"
      "Explorer"
    ];
    exec = "palemoon %u";
    terminal = false;
    type = "Application";
    icon = "palemoon";
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
    startupWMClass = "Pale moon";
    extraConfig = {
      X-MultipleArgs = "false";
    };
    actions = {
      "NewTab" = {
        name = "Open new tab";
        exec = "palemoon -new-tab https://start.palemoon.org";
      };
      "NewWindow" = {
        name = "Open new window";
        exec = "palemoon -new-window";
      };
      "NewPrivateWindow" = {
        name = "Open new private window";
        exec = "palemoon -private-window";
      };
      "ProfileManager" = {
        name = "Open the Profile Manager";
        exec = "palemoon --ProfileManager";
      };
    };
  })];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/palemoon}
    cp -R * $out/lib/palemoon/
    ln -s $out/{lib/palemoon,bin}/palemoon
    for iconpath in chrome/icons/default/default{16,32,48} icons/mozicon128; do
      n=''${iconpath//[^0-9]/}
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      ln -s $out/lib/palemoon/browser/"$iconpath".png $out/share/icons/hicolor/$size/apps/palemoon.png
    done
    # Disable built-in updater
    # https://forum.palemoon.org/viewtopic.php?f=5&t=25073&p=197771#p197747
    # > Please do not take this as permission to change, remove, or alter any other preferences as that is forbidden
    # > without express permission according to the Pale Moon Redistribution License.
    # > We are allowing this one and **ONLY** one exception in order to properly facilitate [package manager] repacks.
    install -Dm644 ${./zz-disableUpdater.js} $out/lib/palemoon/browser/defaults/preferences/zz-disableUpdates.js
    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    # Make optional dependencies available
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        ffmpeg
        libpulseaudio
      ]}"
    )
    wrapGApp $out/lib/palemoon/palemoon
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "palemoon";
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [];
    broken = true; # insecure packages
  };
}
