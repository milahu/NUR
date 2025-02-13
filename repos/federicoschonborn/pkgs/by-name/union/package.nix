{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  kdePackages,
  rapidyaml,
  nix-update-script,
}:

stdenv.mkDerivation (_: {
  pname = "union";
  version = "0-unstable-2025-02-06";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "union";
    rev = "958db41b130ed8e1ca4a14e7938b64ba698b8b17";
    hash = "sha256-1ZS+xMY3LvIbRQDVKEsEFrlocoGdu49eBlK7eMRPovQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtsvg
    kdePackages.karchive
    kdePackages.kcolorscheme
    kdePackages.kconfig
    kdePackages.libplasma
    rapidyaml
  ];

  postPatch = ''
    # Added on ECM 6.11.0
    substituteInPlace CMakeLists.txt --replace-fail "include(ECMGenerateQDoc" "#include(ECMGenerateQDoc"
    substituteInPlace src/CMakeLists.txt --replace-fail "ecm_generate_qdoc" "#ecm_generate_qdoc"
  '';

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

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
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.federicoschonborn ];
  };
})
