{ lib, stdenv, makeWrapper, fetchurl, dpkg, alsa-lib, atk, cairo, cups, dbus, expat
, fontconfig, freetype, gdk-pixbuf, glib, pango, mesa, nspr, nss, gtk3
, at-spi2-atk, gsettings-desktop-schemas, gobject-introspection, wrapGAppsHook3
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, libxshmfence, nghttp2
, libudev0-shim, glibc, curl, openssl, autoPatchelfHook }:

let
  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    libudev0-shim
    nghttp2
    openssl
    stdenv.cc.cc.lib
  ];
in stdenv.mkDerivation rec {
  pname = "insomnia";
  version = "9.3.0";

  src = fetchurl {
    url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.deb";
    hash = "sha256-s69cZ6puCrkvllMfzBZNiZFMtqnAnX7Bf9ZoJsSscGE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    pango
    gtk3
    gsettings-desktop-schemas
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    libxshmfence
    mesa # for libgbm
    nspr
    nss
  ];

  dontBuild = true;
  dontConfigure = true;
  dontWrapGApps = true;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/share/insomnia $out/lib $out/bin

    mv usr/share/* $out/share/
    mv opt/Insomnia/* $out/share/insomnia

    ln -s $out/share/insomnia/insomnia $out/bin/insomnia
    sed -i 's|\/opt\/Insomnia|'$out'/bin|g' $out/share/applications/insomnia.desktop
  '';

  preFixup = ''
    wrapProgramShell "$out/bin/insomnia" \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
        --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';

  meta = with lib; {
    homepage = "https://insomnia.rest/";
    description = "The most intuitive cross-platform REST API Client";
    mainProgram = "insomnia";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
