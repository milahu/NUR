{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  substituteAll,
  pandoc,
  nodejs,
  pnpm_9,
  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick
}:

let
  pnpm = pnpm_9;

  platformIds = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linux-arm64";
  };

  platformId = platformIds.${stdenv.system} or (throw "Unsupported platform: ${stdenv.system}");

  desktopEntry = makeDesktopItem {
    name = "siyuan";
    desktopName = "Siyuan";
    comment = "Personal knowledge management system";
    icon = "siyuan";
    exec = "siyuan %u";
    categories = [ "Office" ];
  };
in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "siyuan";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UIPASTSW7YGpxJJHfCq28M/U6CzyqaJiISZGtE0aDPw=";
  };

  kernel = buildGoModule {
    name = "${finalAttrs.pname}-${finalAttrs.version}-kernel";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/kernel";
    vendorHash = "sha256-s4dW43Qy3Lrc5WPpugQpN6BDEFVxqnorXpp40SGFk7I=";

    patches = [
      (substituteAll {
        src = ./set-pandoc-path.patch;
        pandoc_path = lib.getExe pandoc;
      })
    ];

    # this patch makes it so that file permissions are not kept when copying files using the gulu package
    # this fixes a problem where it was copying files from the store and keeping their permissions
    # hopefully this doesn't break other functionality
    modPostBuild = ''
      chmod +w vendor/github.com/88250/gulu
      substituteInPlace vendor/github.com/88250/gulu/file.go \
          --replace-fail "os.Chmod(dest, sourceinfo.Mode())" "os.Chmod(dest, 0644)"
    '';

    # Set flags and tags as per upstream's Dockerfile
    ldflags = [
      "-s"
      "-w"
      "-X"
      "github.com/siyuan-note/siyuan/kernel/util.Mode=prod"
    ];
    tags = [ "fts5" ];
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
    copyDesktopItems
    imagemagick
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-QSaBNs0m13Pfrvl8uUVqRpP3m8PoOBIY5VU5Cg/G2jY=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    # remove prebuilt pandoc archives
    rm -r pandoc

    # link kernel into the correct starting place so that electron-builder can copy it to it's final location
    mkdir kernel-${platformId}
    ln -s ${finalAttrs.kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build

    npm exec electron-builder -- \
        --dir \
        --config electron-builder-${platformId}.yml \
        -c.electronDist=${electron}/libexec/electron \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/siyuan
    cp -r build/*-unpacked/{locales,resources{,.pak}} $out/share/siyuan

    makeWrapper ${lib.getExe electron} $out/bin/siyuan \
        --chdir $out/share/siyuan/resources \
        --add-flags $out/share/siyuan/resources/app \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}" \
        --inherit-argv0

    runHook postInstall
  '';

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/siyuan-note/siyuan/master/app/src/assets/icon.svg";
    hash = "sha256-S4YCU3wi6sgdKJyfsSL1T6dzZRfasVf92FD2uoHCwWo=";
  };

    # TODO: complete these
  postInstall = ''
    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      convert -background none -resize ''${i}x''${i} ${icon} $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
    done
  '';

  desktopItems = [ desktopEntry ];

  meta = {
    description = "Privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync";
    homepage = "https://b3log.org/siyuan/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "siyuan";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.attrNames platformIds;
  };
})
