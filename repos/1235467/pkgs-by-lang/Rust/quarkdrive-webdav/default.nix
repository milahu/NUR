{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, makeWrapper
, ...
}:
rustPlatform.buildRustPackage rec {
  pname = "quarkdrive-webdav";
  version = "unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "chenqimiao";
    repo = pname;
    rev = "683d54dc96aca9d57d60a4b60df874b2c5061090";
    hash = "sha256-0pijtvasyfuWqiZYlKd59pGqMbNq46KhwoyohZHu55E=";
  };

  cargoHash = "sha256-5g3V0KdVbKXT4obRo+ArSAn1paSAdkB1bfremx7B3+4=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    # Move the original binary to a different name
    mv $out/bin/quarkdrive-webdav $out/bin/.quarkdrive-webdav-unwrapped

    # Create a wrapper script that reads from cookie.txt
    cat > $out/bin/quarkdrive-webdav << EOF
    #!${stdenv.shell}
    cookie_file="\$HOME/.config/quarkdrive-webdav/cookie.txt"
    if [ -f "\$cookie_file" ]; then
      export QUARK_COOKIE="\$(cat "\$cookie_file")"
    fi
    exec "$out/bin/.quarkdrive-webdav-unwrapped" "\$@"
    EOF
    chmod +x $out/bin/quarkdrive-webdav
  '';

  meta = with lib; {
    description = "WebDAV service for Quark Cloud Storage (夸克网盘)";
    homepage = "https://github.com/chenqimiao/quarkdrive-webdav";
    license = licenses.mit;
    maintainers = [ ];
  };
}
