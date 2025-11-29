{
  lib,
  fetchFromGitHub,
  buildGoModule,
}: let
  rev = "ff675896863e7e2993cd779af647b48a8b26aadf";
in
  buildGoModule rec {
    pname = "mihomo-smart";
    version = "0-unstable-${builtins.substring 0 7 rev}";

    src = fetchFromGitHub {
      owner = "vernesong";
      repo = "mihomo";
      inherit rev;
      hash = "sha256-18Ycz4SWCQMfMihzLU6d5in53ZytqL8uSH+WCt24RZI=";
    };

    vendorHash = "sha256-2oVnz/cvtB3xOkqJjw/7J3wyI+faIUyTvOGf1r7rr28=";

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
