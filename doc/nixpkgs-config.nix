# ~/.config/nixpkgs/config.nix

{ pkgs }:

let
  nixosFlakeLock = builtins.fromJSON (builtins.readFile /etc/nixos/flake.lock);
in

{
  #allowUnfree = true; # unrar, etc

  # make nur packages usable from nix-shell
  # https://github.com/nix-community/NUR/#installation
  packageOverrides = pkgs: {
    /*
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    */
    nur = import (pkgs.fetchFromGitHub {
      inherit (nixosFlakeLock.nodes.nur.locked) owner repo rev;
      hash = nixosFlakeLock.nodes.nur.locked.narHash;
    }) {
      inherit pkgs;
      repoOverrides = {
        # mic92 = import ../nur-packages { inherit pkgs; };
        ## remote locations are also possible:
        # mic92 = import (builtins.fetchTarball "https://github.com/your-user/nur-packages/archive/master.tar.gz") { inherit pkgs; };
        milahu = import ../../src/milahu/nur-packages { inherit pkgs; };
      };
    };
  };

}
