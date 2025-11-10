{
  lib,
  static-nix-shell,
}:
let
  self = static-nix-shell.mkBash {
    pname = "vendor-patch-updater";
    srcRoot = ./.;
    pkgs = [ "curl" "nix" ];
    passthru.makeUpdateScript = { ident }: [
      (lib.getExe self)
      ident
    ];
  };
in self
