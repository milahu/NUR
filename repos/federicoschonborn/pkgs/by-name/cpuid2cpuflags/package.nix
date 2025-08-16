{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpuid2cpuflags";
  version = "17";

  src = fetchFromGitHub {
    owner = "projg2";
    repo = "cpuid2cpuflags";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v3GzKOstNNJ/PK1awGbSRpsptRnxhqJ4c9xuNIap89E=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  strictDeps = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "cpuid2cpuflags";
    description = "Tool to generate flags for your CPU";
    homepage = "https://github.com/projg2/cpuid2cpuflags";
    changelog = "https://github.com/projg2/cpuid2cpuflags/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
