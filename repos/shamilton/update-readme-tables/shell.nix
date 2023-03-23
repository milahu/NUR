{ pkgs ? import <nixpkgs> {} }:
let
  customPython = pkgs.python38.buildEnv.override {
    extraLibs = with pkgs.python38Packages; [
      pandas
      tabulate
    ];
  };
  packages-list = import ./packages-list.nix { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = [ customPython ];
  shellHook = ''
    run(){
      python update-readme-tables/update_readme_package_list.py ${packages-list}
    }
  '';
}

