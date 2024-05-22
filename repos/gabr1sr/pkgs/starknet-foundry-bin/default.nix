{
  lib,
  stdenv,
  fetchzip,
  git,
  pkg-config,
  openssl,
  makeWrapper,
  installShellFiles,
  autoPatchelfHook
}:
let
  version = "0.23.0";
  sources = {
    "x86_64-linux" = {
      url = "https://github.com/foundry-rs/starknet-foundry/releases/download/v${version}/starknet-foundry-v${version}-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "0rvvwvgncadcdfl50pb6sbh8zm9gvn99x1b0pj94qj4jz0prjxzl";
    };

    "aarch64-linux" = {
      url = "https://github.com/foundry-rs/starknet-foundry/releases/download/v${version}/starknet-foundry-v${version}-aarch64-unknown-linux-gnu.tar.gz";
      sha256 = "0zhsc0dp0ska0hn2skf0hcxpb4f59xb4ngisfm1pzfpkvjq9bdsj";
    };

    "x86_64-darwin" = {
      url = "https://github.com/foundry-rs/starknet-foundry/releases/download/v${version}/starknet-foundry-v${version}-x86_64-apple-darwin.tar.gz";
      sha256 = "03xigfaqj3n8arvd2ag8b3nab047s7a2k19z5qc7z7r4rg28bzcp";
    };

    "aarch64-darwin" = {
      url = "https://github.com/foundry-rs/starknet-foundry/releases/download/v${version}/starknet-foundry-v${version}-aarch64-apple-darwin.tar.gz";
      sha256 = "1h670wj9fmmpzn01mgv9c5n34pi7n7x6ik17yz939k17qypqjmdn";
    };
  };

  bins = [
    "snforge"
    "sncast"
  ];

  arch = stdenv.hostPlatform.system;
  source = sources.${arch};
in
stdenv.mkDerivation {
  pname = "starknet-foundry-bin";
  version = version;

  src = fetchzip {
    inherit (source) url sha256;
  };

  nativeBuildInputs = [
    pkg-config
    openssl
    makeWrapper
    installShellFiles
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  installPhase =
    let
      path = lib.makeBinPath [ git ];
    in ''
      set -e
      mkdir -p $out/bin
      ${lib.concatMapStringsSep "\n" (bin: ''
      install -m755 -D ./bin/${bin} $out/bin/${bin}
      wrapProgram $out/bin/${bin} --prefix PATH : "${path}"
      '') bins}
    '';

  preFixup = lib.optionalString (stdenv?cc.cc.libgcc) ''
    set -x
    addAutoPatchelfSearchPath ${stdenv.cc.cc.libgcc}/lib
  '';

  installCheckPhase = ''
  $out/bin/snforge --version > /dev/null
  $out/bin/sncast --version > /dev/null
  '';

  doInstallCheck = true;

  meta = {
    description = "Blazing fast toolkit for developing Starknet contracts.";
    homepage = "https://github.com/foundry-rs/starknet-foundry";

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    
    license = lib.licenses.mit;
  };
}
