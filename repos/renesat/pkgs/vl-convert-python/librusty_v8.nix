{
  stdenv,
  fetchurl,
}: let
  fetch_librusty_v8 = args:
    fetchurl {
      name = "librusty_v8-${args.version}";
      url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
      sha256 = args.shas.${stdenv.hostPlatform.system};
      meta = {inherit (args) version;};
    };
in
  fetch_librusty_v8 {
    version = "0.83.2";
    shas = {
      x86_64-linux = "sha256-RJNdy5jRZK3dTgrHsWuZZAHUyy1EogyNNuBekZ3Arrk=";
      aarch64-linux = "sha256-Ylix7nVs9vTlDIZc5hd3ZdR8+e2JHBWTQxCVv2Hp/cA=";
      x86_64-darwin = "sha256-niZN76/CXv3px97b5ccJAHgZfeHPSTt4CPQCUGw9EfQ=";
      aarch64-darwin = "sha256-ZAfY4dFjr2pTU2gqpLCujv9f6pHnYYAOcvDT54lEdvM=";
    };
  }
