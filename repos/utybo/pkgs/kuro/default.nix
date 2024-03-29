# Adapted from the original github's release.nix

{ lib
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, mkYarnPackage
, electron_22
, yarn2nix
}:

let
  appName = "kuro";
  executableName = appName;
  electron = electron_22;
in
mkYarnPackage rec {
  name = appName;
  version = "8.1.8";

  src = fetchFromGitHub {
    owner = "davidsmorais";
    repo = name;
    rev = "v${version}";
    hash = "sha256-+4HgH8HBQ+KIN2u+3ZsPMORPl5C7BO+rXR0RsA79EGg=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    # resources
    echo "Installing resources..."
    mkdir -p "$out/share/kuro/electron"
    cp -r './deps/kuro/static' "$out/share/kuro/electron"
    cp -r './deps/kuro/src' "$out/share/kuro/electron"
    cp -r './deps/kuro/index.js' "$out/share/kuro/electron"
    cp -r './node_modules' "$out/share/kuro/electron"

    # icons
    echo "Installing icons..."
    for size in 16x16 24x24 32x32 48x48 64x64 72x72 96x96 128x128 192x192 256x256 512x512 1024x1024; do
      install -Dm644 ./deps/kuro/static/Icon.png $out/share/icons/hicolor/$size/apps/kuro.png
    done

    # desktop item
    echo "Installing desktop item..."
    mkdir -p "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
      --argv0 "kuro" \
      --add-flags "$out/share/kuro/electron" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland}}"
  '';

  # Do not attempt generating a tarball for contents again.
  # note: `doDist = false;` does not work.
  distPhase = ''
    true
  '';

  desktopItem = with lib;
    makeDesktopItem {
      name = "kuro";
      exec = executableName;
      icon = "kuro";
      desktopName = "kuro";
      genericName = "Microsoft To-Do Client";
      comment = concatStringsSep " "
        (splitString "\n" meta.description);
      categories = [ "Office" ];
      startupWMClass = "kuro";
    };

  meta = with lib; {
    description = ''
      kuro is an unofficial, featureful, open source,
      community-driven, free Microsoft To-Do app,
      used by people in more than 120 countries.
    '';
    homepage = "https://github.com/pythonInRelay/kuro";
    license = licenses.mit;
    inherit (electron.meta) platforms;
  };
}
