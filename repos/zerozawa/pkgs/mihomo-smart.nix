{
  lib,
  fetchFromGitHub,
  buildGoModule,
}: let
  rev = "adc0d2be2332b6f4868568db6dab09cd78a8bd97";
in
  buildGoModule rec {
    pname = "mihomo-smart";
    version = "0-unstable-${builtins.substring 0 7 rev}";

    src = fetchFromGitHub {
      owner = "vernesong";
      repo = "mihomo";
      inherit rev;
      hash = "sha256-xkpn7DzMxF7lon4wHbwlYw3S5GI5QpeTdhiv/DJ9nno=";
    };

    vendorHash = "sha256-NOqgN4qZwh+eW8uDVrg/Jk4KHXMgSVdRoKsR1P30osc=";

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
