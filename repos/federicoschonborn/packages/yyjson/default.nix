{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yyjson";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ibireme";
    repo = "yyjson";
    rev = finalAttrs.version;
    hash = "sha256-iRMjiaVnsTclcdzHjlFOTmJvX3VP4omJLC8AWA/EOZk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The fastest JSON library in C";
    homepage = "https://github.com/ibireme/yyjson";
    changelog = "https://github.com/ibireme/yyjson/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    # maintainers = [ lib.maintainers.federicoschonborn ];
  };
})
