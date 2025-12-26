{ buildGoModule
, fetchFromGitHub
, lib
, unstableGitUpdater
}:

buildGoModule (incremental-compress: {
  pname = "incremental-compress";
  version = "0-unstable-2025-03-30";

  src = fetchFromGitHub {
    owner = "scottlaird";
    repo = "incremental-compress";
    rev = "30c9c0de71d5f988fe0b5fd70834c1be1088ee95";
    hash = "sha256-Qbp8ldpD81S66MBPk0Y1jM45GVnGVWoTsvS1eV+PXk0=";
  };

  vendorHash = "sha256-yh6dXS0TCcafqFe9PUokyWqg6lWEMIy6ddI4YgUtxDE=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/${incremental-compress.meta.mainProgram} --help
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Incremental compression tool for static page generators";
    homepage = "https://github.com/scottlaird/incremental-compress";
    license = lib.licenses.asl20;
    mainProgram = "incremental-compress";
  };
})
