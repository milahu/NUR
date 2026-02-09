{
  fetchFromCodeberg,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "fuseftp";
  version = "0-unstable-2026-02-07";

  src = fetchFromCodeberg {
    owner = "nettika";
    repo = "fuseftp";
    rev = "1a7a91d83bb9794db2bb4dd9bed32bb3dfc984c5";
    hash = "sha256-gtTmiIOKKr9ECa1ncmURhZp03jYSniBGjSHVGnd3P1A=";
  };

  cargoHash = "sha256-fmE2akPnoZIiS5uBfFBfT3tsvhVM9m0vzQWqp1E3064=";

  postInstall = ''
    ln -s fuseftp $out/bin/mount.fuse.ftp
    ln -s fuseftp $out/bin/mount.fuseftp
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "branch" ];
  };

  meta = {
    description = "Mount an FTP filesystem using FUSE";
    homepage = "https://codeberg.org/nettika/fuseftp";
    maintainers = with lib.maintainers; [ colinsane ];
    mainProgram = "fuseftp";
  };
}
