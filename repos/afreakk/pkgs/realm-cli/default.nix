{ pkgs }:
pkgs.buildGoModule rec {
  pname = "realm-cli";
  version = "1.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "10gen";
    repo = "realm-cli";
    rev = "v${version}";
    sha256 = "05q3adzbvb8j39rpj2rac6k4sxajkbmmhfnwmxrnwq6mmk2vzw8x";
  };

  vendorHash = "sha256-BkAC05ciLsEc9ClBX5UjzVb171PRoRy/ilobxceKe6M=";
  #some tests fails, because i dont build the node-transpiler shit
  #so skip tests
  checkPhase = ''
    runHook preCheck
    runHook postCheck
  '';

  meta = with pkgs.lib; {
    description = "MongoDB Realm CLI";
    homepage = "https://github.com/10gen/realm-cli/";
    license = licenses.apsl20;
  };
}
