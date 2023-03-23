{ lib
, rustPlatform
, yabridge
, makeWrapper
, wine
}:

rustPlatform.buildRustPackage {
  pname = "yabridgectl";
  version = yabridge.version;

  src = yabridge.src;
  sourceRoot = "source/tools/yabridgectl";
  cargoSha256 = "sha256-qr6obmabcO3n+DxMxkj3mbpzR/Wn6eOg2J99/FarMVs=";

  patches = [
    # Patch yabridgectl to search for the chainloader through NIX_PROFILES
    ./chainloader-from-nix-profiles.patch

    # Dependencies are hardcoded in yabridge, so the check is unnecessary and likely incorrect
    ./remove-dependency-verification.patch
  ];

  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram "$out/bin/yabridgectl" \
      --prefix PATH : ${lib.makeBinPath [
        wine # winedump
      ]}
  '';

  meta = with lib; {
    description = "A small, optional utility to help set up and update yabridge for several directories at once";
    homepage = "${yabridge.src.meta.homepage}/tree/${yabridge.version}/tools/yabridgectl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = yabridge.meta.platforms;
  };
}
