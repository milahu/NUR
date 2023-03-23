{ lib
, fetchurl
, fetchFromGitHub
, symlinkJoin
, buildGoModule
, runCommand
, makeWrapper
, v2ray-geoip
, v2ray-domain-list-community
, assetsDir ? null
}:
let
  assetsDrv =
    if assetsDir != null then assetsDir else
    symlinkJoin {
      name = "v2ray-assets";
      paths = [
        "${v2ray-geoip}/share/v2ray"
        "${v2ray-domain-list-community}/share/v2ray"
      ];
    };

  core = buildGoModule rec {
    pname = "v2ray";
    version = "v5.4.0";
    src = fetchFromGitHub ({
      owner = "v2fly";
      repo = "v2ray-core";
      rev = version;
      fetchSubmodules = false;
      sha256 = "sha256-dgWpfpJiPYQmVg7CHRE8f9hX5vgC2TuLpTfMAksDurs=";
    });
    vendorSha256 = "sha256-BEMdh1zQdjVEu0GJt6KJyWN5P9cUHfs04iNZWxzZ0Yo=";

    doCheck = false;

    buildPhase = ''
      buildFlagsArray=(-v -p $NIX_BUILD_CORES -ldflags="-s -w")
      runHook preBuild
      go build "''${buildFlagsArray[@]}" -o v2ray ./main
      runHook postBuild
    '';

    installPhase = ''
      install -Dm755 v2ray -t $out/bin
    '';

    meta = {
      homepage = "https://www.v2fly.org/en_US/";
      description = "A platform for building proxies to bypass network restrictions";
      license = lib.licenses.mit;
    };
  };
in
runCommand core.name
{
  inherit (core) version meta;
  nativeBuildInputs = [ makeWrapper ];
} ''
  for file in ${core}/bin/*; do
    makeWrapper "$file" "$out/bin/$(basename "$file")" \
      --set-default V2RAY_LOCATION_ASSET ${assetsDrv}
  done
''
