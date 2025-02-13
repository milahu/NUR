{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "finch";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "runfinch";
    repo = "finch";
    tag = "v${version}";
    hash = "sha256-xWXt3N/jucqGy0Z+RtmrM44k2zeIdsJwvhtGAps9tlI=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-MZ2SgDBYB+QycAc/Tdl6g0VBHDZxXBQhl8l4mAn6LxM=";

  subPackages = [ "cmd/finch" ];

  ldflags = [ "-X github.com/runfinch/finch/pkg/version.Version=${version}" ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkFlags = [ "-skip=TestVersionAction_run" ];

  meta = {
    description = "Client for container development";
    homepage = "https://github.com/runfinch/finch";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sikmir ];
    platforms = lib.platforms.darwin;
    skip.ci = true;
  };
}
