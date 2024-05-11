{ stdenv
, pkgs
, lib
, ...
}:
let
  mainProgram = "Forkgram";
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
pkgs.telegram-desktop.overrideAttrs (
  prev: rec {
    pname = "forkgram";
    inherit (sources.forkgram) version src;
    postInstall = ''
      # taken from https://aur.archlinux.org/packages/forkgram

      # Remove default icons
      find "$out/share/icons" -name telegram.png -delete
      rm "$out/share/applications/org.telegram.desktop.desktop" "$out/share/metainfo/org.telegram.desktop.metainfo.xml"

      # Rename executable
      mv -v "$out"/bin/{telegram-desktop,Forkgram}

      # Main icons
      install -dm755 "$out/share/pixmaps/"
      install -Dm644 "${src}/Telegram/Resources/art/forkgram/logo_256.png" "$out/share/pixmaps/"

      # Desktop launcher
      install -Dm644 "${./${pname}.desktop}" "$out/share/applications/${pname}.desktop"

      # Icons
      local icon_size icon_dir
      for icon_size in 16 32 48 64 128 256 512; do
        icon_dir="$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps"
        install -d "''${icon_dir}"
        install -m644 "${src}/Telegram/Resources/art/icon''${icon_size}.png" "''${icon_dir}/${pname}.png"
      done
    '';
    postFixup =
      lib.optionalString stdenv.isLinux ''
        # This is necessary to run Telegram in a pure environment.
        # We also use gappsWrapperArgs from wrapGAppsHook.
        wrapProgram $out/bin/${mainProgram} \
          "''${gappsWrapperArgs[@]}" \
          "''${qtWrapperArgs[@]}" \
          --suffix PATH : ${lib.makeBinPath [pkgs.xdg-utils]}
      ''
      + lib.optionalString stdenv.isDarwin ''
        wrapQtApp $out/Applications/${mainProgram}.app/Contents/MacOS/${mainProgram}
      '';
    meta = with lib; {
      description = "Fork of the Telegram Desktop messaging app";
      longDescription = ''
        Forkgram is the fork of the official Telegram Desktop application.
        This fork does not fundamentally change the official client and adds only some useful small features.
      '';
      license = licenses.gpl3Only;
      platforms = platforms.all;
      homepage = "https://github.com/forkgram/tdesktop/";
      changelog = "https://github.com/forkgram/tdesktop/releases/tag/v${version}";
      maintainers = with maintainers; [ ];
      inherit mainProgram;
    };
  }
)
