{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "uassets";
  version = "0-unstable-2025-10-31";
  src = fetchFromGitHub {
    owner = "uBlockOrigin";
    repo = "uAssets";
    rev = "6bf879e4def6e60d1665c8db9685441c0c7197ee";
    hash = "sha256-HUlu4Vl7eSxWmON6zxtUrMaILoqTL4d/ayB6y4nZo4U=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/filters
    for f in $(ls filters); do
      cp "filters/$f" "$out/share/filters/ublock-$f"
    done
    cp thirdparties/easylist/* $out/share/filters
    cp thirdparties/pgl.yoyo.org/as/serverlist $out/share/filters/pgl-serverlist.txt
    cp thirdparties/urlhaus-filter/*.txt $out/share/filters
  '';

  passthru.updateScript = nix-update-script {
    # XXX(2024/05/26): why does `--version unstable` not work, but `--version branch` *does*??
    extraArgs = [ "--version" "branch" ];
  };

  meta = with lib; {
    homepage = "https://github.com/uBlockOrigin/uAssets";
    description = "official uBlock Origin filter lists";
    maintainers = with maintainers; [ colinsane ];
  };
}
