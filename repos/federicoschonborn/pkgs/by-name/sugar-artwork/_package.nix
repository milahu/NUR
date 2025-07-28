{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  iconnamingutils,
  pkg-config,
  python3,
  xorg,
  gtk3,
  nix-update-script,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.empy ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sugar-artwork";
  version = "0.121";

  src = fetchFromGitHub {
    owner = "sugarlabs";
    repo = "sugar-artwork";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kv8LAD9hAcJfh5IkbqVw4Yc/GaahaCgY5MQ7rnltowI=";
  };

  patches = [
    # Port to empy 4.2
    (fetchpatch {
      url = "https://github.com/sugarlabs/sugar-artwork/commit/84a0f2c115ddabc0d8ec16cc09080d62c067a90f.patch";
      hash = "sha256-8ScKqtl7AjROs2tu0SPh3yYYigcGgbaTCTkCItQIBuE=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    iconnamingutils
    pkg-config
    pythonEnv
    xorg.xcursorgen
  ];

  buildInputs = [ gtk3 ];

  configureFlags = [ (lib.withFeature false "gtk2") ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sugar icons and themes";
    homepage = "https://github.com/sugarlabs/sugar-artwork";
    changelog = "https://github.com/sugarlabs/sugar-artwork/blob/v${finalAttrs.version}/NEWS";
    license = with lib.licenses; [
      lgpl21Only
      asl20
    ];
    platforms = lib.platforms.linux;
  };
})
