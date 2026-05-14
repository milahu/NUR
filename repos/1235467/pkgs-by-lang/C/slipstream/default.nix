{ lib
, fetchFromGitHub
, stdenv
, cmake
, makeWrapper
, meson
, ninja
, openssl
, pkg-config
,
}:

let
  picotlsSrc = fetchFromGitHub {
    owner = "h2o";
    repo = "picotls";
    rev = "5a4461d8a3948d9d26bf861e7d90cb80d8093515";
    fetchSubmodules = true;
    hash = "sha256-Io0QZazs9BCXIYf3xZY7kgyRAiFexgzhcGFR+uh3jCI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "slipstream";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "EndPositive";
    repo = "slipstream";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-YXtQWMqccXHAV17tveXWm3zXgt3Ovckg5yIIUfiJO+Y=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ openssl ];

  mesonBuildType = "release";

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "{'PICOQUIC_FETCH_PTLS': 'ON'}," "{'PICOQUIC_FETCH_PTLS': 'ON'}, {'FETCHCONTENT_SOURCE_DIR_PICOTLS': '${picotlsSrc}'}," 
  '';

  dontUseCmakeConfigure = true;
  dontUseMesonInstall = true;
  installPhase = ''
    runHook preInstall

    install -Dm755 slipstream-client $out/bin/slipstream-client
    install -Dm755 slipstream-server $out/libexec/slipstream-server-unwrapped

    mkdir -p $out/share/slipstream/certs
    cp -r ../certs/. $out/share/slipstream/certs/

    makeWrapper $out/libexec/slipstream-server-unwrapped $out/bin/slipstream-server \
      --add-flags "--cert $out/share/slipstream/certs/cert.pem" \
      --add-flags "--key $out/share/slipstream/certs/key.pem"

    runHook postInstall
  '';

  meta = with lib; {
    description = "High-performance covert channel over DNS powered by QUIC multipath";
    homepage = "https://github.com/EndPositive/slipstream";
    changelog = "https://github.com/EndPositive/slipstream/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    mainProgram = "slipstream-client";
    platforms = platforms.linux;
  };
})
