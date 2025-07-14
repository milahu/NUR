{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
  libpng,
  motif,
  xorg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncsa-mosaic";
  version = "0-unstable-2023-01-30";

  src = fetchFromGitHub {
    owner = "alandipert";
    repo = "ncsa-mosaic";
    rev = "2e9a6053fa39487c0f427dc423bedd3747724bbb";
    hash = "sha256-imcn4zz5Jp+5b155Rd6XKgumif/0yUGT3vSf23x2arw=";
  };

  buildInputs = [
    libjpeg
    libpng
    motif
    xorg.libXext
    xorg.libXmu
    xorg.libXpm
    xorg.libXt
  ];

  makeFlags = [ "linux" ];

  installPhase = ''
    runHook preInstall

    install -Dm00755 src/Mosaic -t $out/bin
    install -Dm00644 docs/resources.html -t $out/share/doc/ncsa-mosaic

    runHook postInstall
  '';

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-fcommon"
    "-std=gnu89"
    "-Wno-implicit-function-declaration"
    "-Wno-implicit-int"
    "-Wno-incompatible-pointer-types"
    "-Wno-int-conversion"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "Mosaic";
    description = "NCSA Mosaic 2.7";
    homepage = "https://github.com/alandipert/ncsa-mosaic";
    changelog = "https://github.com/alandipert/ncsa-mosaic/blob/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.unfree; # TODO
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
