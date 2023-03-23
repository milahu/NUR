{ lib, buildGoModule, fetchgit, mpv }:
buildGoModule rec {
  pname = "ff2mpv-go";
  version = "1.0.1";

  src = fetchgit {
    url = "https://git.clsr.net/util/ff2mpv-go/";
    rev = "v${version}";
    sha256 = "sha256-e/AuOA3isFTyBf97Zwtr16yo49UdYzvktV5PKB/eH/s=";
  };

  vendorHash = null;

  postPatch = ''
    sed -i -e 's,"mpv","${mpv}/bin/mpv",' ff2mpv.go
  '';

  postInstall = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    $out/bin/ff2mpv-go --manifest > "$out/lib/mozilla/native-messaging-hosts/ff2mpv.json"
  '';

  meta = with lib; {
    description = ''
      Native messaging host for ff2mpv written in Go.
    '';
    homepage = "https://git.clsr.net/util/ff2mpv-go/";
    license = licenses.publicDomain;
  };
}
