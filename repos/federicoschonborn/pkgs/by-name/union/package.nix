{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  kdePackages,
  cxx-rust-cssparser,
  rapidyaml,
  nix-update-script,
  withCSSInput ? true,
}:

stdenv.mkDerivation (_: {
  pname = "union";
  version = "0-unstable-2025-08-07";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "union";
    rev = "90702cba9928070b58f28f370f49e1a83c067b1b";
    hash = "sha256-o1Od98Nyg4elJ/J3gb6DryjL3xg2Kber2G/CTT4nK4o=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.karchive
    kdePackages.kcolorscheme
    kdePackages.kconfig
    kdePackages.libplasma
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtsvg
    rapidyaml
  ]
  ++ lib.optional withCSSInput cxx-rust-cssparser;

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "WITH_CSS_INPUT" withCSSInput)
  ];

  postPatch = ''
    # Added on ECM 6.11.0
    substituteInPlace CMakeLists.txt --replace-fail "include(ECMGenerateQDoc" "#include(ECMGenerateQDoc"
    substituteInPlace src/CMakeLists.txt --replace-fail "ecm_generate_qdoc" "#ecm_generate_qdoc"
  '';

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A Qt style supporting both QtQuick and QtWidgets";
    homepage = "https://invent.kde.org/plasma/union";
    license = with lib.licenses; [
      bsd2
      cc0
      gpl2Only
      gpl3Only
      lgpl21Only
      lgpl3Only
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
