{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dgop";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-QCJbcczQjUZ+Xf7tQHckuP9h8SD0C4p0C8SVByIAq/g=";
  };

  vendorHash = "sha256-+5rN3ekzExcnFdxK2xqOzgYiUzxbJtODHGd4HVq6hqk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.buildTime=1970-01-01_00:00:00"
    "-X main.Commit=${finalAttrs.version}"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $GOPATH/bin/cli $out/bin/dgop
  '';

  meta = {
    description = "API & CLI for System Resources";
    homepage = "https://github.com/AvengeMedia/dgop";
    mainProgram = "dgop";
    binaryNativeCode = true;
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})
