{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "emitter";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "emitter-io";
    repo = "emitter";
    tag = "v${version}";
    hash = "sha256-eWBgRG0mLdiJj1TMSAxYPs+8CqLNaFUOW6/ghDn/zKE=";
  };

  vendorHash = "sha256-6K9KAvb+05nn2pFuVDiQ9IHZWpm+q01su6pl7CxXxBY=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "High performance, distributed and low latency publish-subscribe platform";
    homepage = "https://emitter.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sikmir ];
    mainProgram = "emitter";
  };
}
