{ static-nix-shell }:
static-nix-shell.mkPython3 {
  pname = "sane-dtmf-generator";
  srcRoot = ./.;
  pkgs = [ "python3.pkgs.numpy" "python3.pkgs.scipy" ];
}
