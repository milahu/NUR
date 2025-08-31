{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yyjson";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ibireme";
    repo = "yyjson";
    rev = finalAttrs.version;
    hash = "sha256-1CYnEgUMUc7eqdkv6M/KyL/MdVQBMov9HgLCycF6++w=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    description = "The fastest JSON library in C";
    homepage = "https://github.com/ibireme/yyjson";
    changelog = "https://github.com/ibireme/yyjson/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
