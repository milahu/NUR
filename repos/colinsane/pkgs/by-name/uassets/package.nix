{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "uassets";
  version = "0-unstable-2026-02-08";
  src = fetchFromGitHub {
    owner = "uBlockOrigin";
    repo = "uAssets";
    rev = "6004050ee719bb08dbc640bb1361323003726b3f";
    hash = "sha256-+k0fcXeSXiQoNXGf2HwjEJWT50ETO3CTrfKfRCL3uw0=";
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
