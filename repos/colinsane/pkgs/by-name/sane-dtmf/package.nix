{ static-nix-shell }:
let
  sane-dtmf-generator = static-nix-shell.mkPython3 {
    pname = "sane-dtmf-generator";
    srcRoot = ./.;
    pkgs = [ "python3.pkgs.numpy" "python3.pkgs.scipy" ];
  };
in
  # TODO: create a derivation which houses the actual tones,
  # by *invoking* the dtmf generator
  sane-dtmf-generator
