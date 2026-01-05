{
  lib,
  fetchFromGitHub,
  buildGoModule,
}: let
  rev = "d45278b37cc5bca8f52ad83ef851fd2d6f67c6dd";
in
  buildGoModule rec {
    pname = "mihomo-smart";
    version = "0-unstable-${builtins.substring 0 7 rev}";

    src = fetchFromGitHub {
      owner = "vernesong";
      repo = "mihomo";
      inherit rev;
      hash = "sha256-iHeahsco01rTC15G4hG5XtR5gIX86jxN+NHG15wsFf0=";
    };

    vendorHash = "sha256-pp54pvr2L8mlpBaYJPm57NTJIERkYWv5usNzYX0LhgI=";

    excludedPackages = ["./test"];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/metacubex/mihomo/constant.Version=${version}"
    ];

    tags = [
      "with_gvisor"
    ];

    # network required
    doCheck = false;

    postInstall = ''
      mv $out/bin/mihomo $out/bin/mihomo-smart
    '';

    meta = with lib; {
      description = "A rule-based tunnel in Go with Smart Groups functionality (fork of mihomo)";
      homepage = "https://github.com/vernesong/mihomo";
      license = licenses.gpl3Only;
      mainProgram = pname;
      platforms = platforms.all;
      sourceProvenance = with sourceTypes; [fromSource];
    };
  }
