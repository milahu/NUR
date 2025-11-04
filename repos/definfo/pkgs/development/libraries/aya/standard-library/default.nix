{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation rec {
  pname = "standard-library";
  version = "0.39";

  src = fetchFromGitHub {
    owner = "aya-prover";
    repo = "aya-dev";
    tag = "v${version}";
    hash = "sha256-QdvhAckdJyRESKp1r+VYOaWowH8MtDEPo8VilaxMNuM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R $src/cli-impl/src/test/resources/shared/{src/,aya.json} $out/

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.aya-prover.org";
    description = "Standard library for Aya Prover";
    licence = lib.licenses.mit;
    maintainers = with lib.maintainers; [ definfo ];
    platforms = [
      "aarch64-windows"
      "x86_64-windows"
      "aarch64-linux"
      "x86_64-linux"
      "riscv64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
