{ lib
, fetchFromGitHub
, rustPlatform
, ffmpeg
, svt-av1
, libvmaf
, git
, nasm
, pkg-config
, ...
}:
let
  pname = "ab-av1";
  version = "v0.7.9";
  sha256 = "sha256-B1Sp4eQ2kUEX85DIXjffnG0esrcJnPcjdzdQ2oEbYH0=";
  cargoHash = "sha256-/auG4lYK9CE8tl7H5VdfCgGsIfpfY2AtE10pKXrDFNo=";
in
rustPlatform.buildRustPackage {
  inherit pname version cargoHash;

  src = fetchFromGitHub {
    owner = "alexheretic";
    repo = pname;
    rev = version;
    inherit sha256;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    git
    libvmaf
    svt-av1
  ];

  meta = with lib; {
    description = "AV1 re-encoding using ffmpeg, svt-av1 & vmaf";
    homepage = "https://github.com/alexheretic/ab-av1";
    license = licenses.mit;
    maintainers = [ ];
  };
}
