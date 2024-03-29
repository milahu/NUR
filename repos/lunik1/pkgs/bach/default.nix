{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "bach";
  version = "0.3";

  src = fetchFromGitLab {
    owner = "lunik1";
    repo = pname;
    rev = "acb5120fd16b188f9214eb1fabfc1c49dbd0b138";
    hash = "sha256-t0usWsfuXSWBi63V7tDindIvrBwDgyO9euMjIUf/bMI=";
  };

  cargoHash = "sha256-dxCkt85b+7nSYBh861PuvDU/AeeEhYgk9r3GjPBQt3o=";

  meta = with lib; {
    description = "A tool to help you find defined compose sequences.";
    homepage = "https://gitlab.com/lunik1/bach";
    license = licenses.bsd2Patent;
    maintainers = [ maintainers.lunik1 ];
  };
}
