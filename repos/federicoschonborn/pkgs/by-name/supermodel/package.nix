{
  lib,
  stdenv,
  fetchFromGitHub,
  libGLU,
  SDL2,
  SDL2_net,
  xorg,
  zlib,
  nix-update-script,

  debugBuild ? false,
  enableNetBoard ? true,
  enableDebugger ? true,
}:

stdenv.mkDerivation {
  pname = "supermodel";
  version = "0-unstable-2024-07-05";

  src = fetchFromGitHub {
    owner = "trzy";
    repo = "Supermodel";
    rev = "ee5d6523c85f5fe8eb61768f10edfdc3b5f9858f";
    hash = "sha256-F1Ojrokfg+hpvsBrYW4KX4NDzCFG/OkC8Ci+YSQFEk0=";
  };

  buildInputs = [
    libGLU
    SDL2
    SDL2_net
    xorg.libX11
    zlib
  ];

  makeFlags =
    [
      "-f"
      "Makefiles/Makefile.UNIX"
    ]
    ++ lib.optional debugBuild "DEBUG=1"
    ++ lib.optional enableNetBoard "NET_BOARD=1"
    ++ lib.optional enableDebugger "ENABLE_DEBUGGER=1";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/supermodel $out/bin

    runHook postInstall
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    mainProgram = "supermodel";
    description = "Sega Model 3 arcade machine emulator";
    homepage = "https://github.com/trzy/Supermodel";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.federicoschonborn ];
  };
}
