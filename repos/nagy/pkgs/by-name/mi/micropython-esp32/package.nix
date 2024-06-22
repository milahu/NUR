# FIXME: This still needs a disabled sandbox to build
# upstream issue: https://github.com/espressif/idf-component-manager/issues/54
{
  callPackage,
  fetchFromGitHub,
  micropython,
  esp-idf-esp32 ? (
    let
      esp-idf-full = callPackage "${
        fetchFromGitHub {
          owner = "mirrexagon";
          repo = "nixpkgs-esp-dev";
          rev = "7972602ad6bff6c87ec84b0467acfc7ea2046501";
          hash = "sha256-KEbZ88PloMeUd7s+JskJDQz2Z6xXoCbrTQ1no3aaGzs=";
        }
      }/pkgs/esp-idf" { };
    in
    # Copied from https://github.com/mirrexagon/nixpkgs-esp-dev/blob/master/overlay.nix#L33
    esp-idf-full.override {
      toolsToInclude = [
        "xtensa-esp32-elf"
        "esp32ulp-elf"
        "openocd-esp32"
        "xtensa-esp-elf-gdb"
      ];
      # for esp32s3:
      # toolsToInclude = [
      #   "xtensa-esp32s3-elf"
      #   "esp32ulp-elf"
      #   "openocd-esp32"
      #   "xtensa-esp-elf-gdb"
      # ];
    }
  ),
}:

micropython.overrideAttrs (
  {
    nativeBuildInputs ? [ ],
    ...
  }:
  {
    nativeBuildInputs = nativeBuildInputs ++ [ esp-idf-esp32 ];

    dontUseCmakeConfigure = true;

    doCheck = false;

    buildPhase = ''
      runHook preBuild

      HOME=$PWD \
        make -C ports/esp32 BOARD=ESP32_GENERIC

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm444 ports/esp32/build-ESP32_GENERIC/firmware.bin -t $out/share/micropython/

      runHook postInstall
    '';
  }
)
