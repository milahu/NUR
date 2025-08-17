{
  lib,
  nodejs_20,
  buildNpmPackage,
  fetchurl,
  fetchNpmDeps,
  runCommand,
  nix-update-script,
}:
let
  pname = "qwen-code";
  version = "0.0.7";
  srcHash = "sha256-DEaa4uEiuCIBPAjiHCOgPxvtsNXl+82wMjAnypsf+00=";
  npmDepsHash = "sha256-PPw1HHAIPsKabYqmKz00jOrYj65OR78Y6WXRYZy/Zn8=";

  src = runCommand "gemini-cli-src-with-lock" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-${version}.tgz";
        hash = "${srcHash}";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage (finalAttrs: {
  inherit pname version src;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "${npmDepsHash}";
  };

  # The package from npm is already built
  dontNpmBuild = true;

  nodejs = nodejs_20;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Qwen-code is a coding agent that lives in digital world";
    homepage = "https://github.com/QwenLM/qwen-code";
    mainProgram = "qwen";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})
