{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  callPackage,
  nix-update-script,
  writeScript,
  zon2nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ziggy";
  version = "0.0.1-unstable-2025-07-08";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "eeb21acc0a369dca503167fe963f4f5a7eda2659";
    hash = "sha256-5gW1hpJcnayA6veLWCiksGpfZBZX3UsQmYC4XlZRaEo=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  zigDeps = callPackage ./deps.nix { };

  postPatch = ''
    ln -s $zigDeps $ZIG_GLOBAL_CACHE_DIR/p
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

    updateDeps = writeScript "update-deps" ''
      ${lib.getExe zon2nix} ${finalAttrs.src} > deps.nix
    '';
  };

  meta = {
    mainProgram = "ziggy";
    description = "A data serialization language for expressing clear API messages, config files, etc";
    homepage = "https://github.com/kristoff-it/ziggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ federicoschonborn ];
    broken = lib.versionOlder zig.version "0.14";
    inherit (zig.meta) platforms;
  };
})
