{ expect
, fetchFromGitHub
, lib
, makeWrapper
, stdenv
, testers
, unstableGitUpdater
, writeScriptBin

  # Dependencies
, openssl
, python3
}:

let
  inherit (builtins) toFile;
  inherit (lib) getExe getExe' licenses makeBinPath;
in
stdenv.mkDerivation (udon: {
  pname = "udon";
  version = "0-unstable-2026-04-15";

  src = fetchFromGitHub {
    owner = "treedavies";
    repo = "udon";
    rev = "fe0c5cd91cfc4c20901c39c869bae68a060e69f8";
    hash = "sha256-fzsb/ml+FeSC6WbP4dAEpBpiR3EKDOejDlpLzTQZBS4=";
  };

  patches = [
    # Don’t check for an `sqlite3` executable; SQLite is compiled into Python
    (toFile "skip-verify-sqlite3.patch" ''
      --- a/src/test_libudon.py
      +++ b/src/test_libudon.py
      @@ -1273 +1272,0 @@
      -	verify_sqlite3()
    '')
  ];

  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    (python3.withPackages (ps: with ps; [
      config
      cryptography
      grpcio
    ]))
  ];
  buildPhase = ''
    runHook preBuild

    ${getExe' python3.pkgs.grpcio-tools "python-grpc-tools-protoc"} \
      --proto_path='src' \
      --python_out='src' \
      --grpc_python_out='src' \
      'src/udon.proto'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/share/udon"
    cp --target-directory "$out/share/udon" \
      'src/libudon.py' \
      'src/test_libudon.py' \
      'src/udon' \
      'src/udon_init.py' \
      'src/udon_pb2_grpc.py' \
      'src/udon_pb2.py' \
      'src/udon-server'

    makeWrapper "$out/share/udon/udon" "$out/bin/udon"
    makeWrapper "$out/share/udon/udon_init.py" "$out/bin/udon-init" \
      --prefix PATH : ${makeBinPath [ openssl ]}
    makeWrapper "$out/share/udon/udon-server" "$out/bin/udon-server"

    runHook postInstall
  '';

  passthru.tests = {
    libudon = testers.nixosTest {
      name = "libudon";
      nodes.server = {
        imports = [ <nixpkgs/nixos/tests/common/user-account.nix> ];

        environment.systemPackages = [
          udon.finalPackage
          (writeScriptBin "udon-init-noninteractive" ''
            #!${getExe expect} -f
            spawn udon-init
            expect "Create TEST keys A and B? (y/n): "; send "y\r"
            expect "Create new TLS Certs? (y/n): "; send "y\r"
            expect "Use this hostname for cert? (y/n): "; send "y\r"
            expect "Create a user key? (y/n): "; send "y\r"
            expect "Name of key: "; send "Example\r"
            expect "Desired Key size? (default=4096): "; send "\r"
          '')
        ];
      };

      testScript = ''
        server.wait_for_unit("multi-user.target")
        server.succeed("su - alice -c udon-init-noninteractive")
        server.execute("su - alice -c udon-server >&2 &")
        server.wait_for_open_port(50051)
        server.succeed("su - alice -c ${udon.finalPackage}/share/udon/test_libudon.py")
      '';
    };
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Network messaging library and tools";
    homepage = "https://github.com/treedavies/udon";
    license = licenses.gpl2Only;
    mainProgram = "udon";
  };
})
