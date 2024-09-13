{
  description = "Wrap Gradle builds with Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (nixpkgs) lib;
      in
      {
        builders = {
          inherit (self.packages.${system}.gradle2nix) buildGradlePackage buildMavenRepo;
          default = self.packages.${system}.buildGradlePackage;
        };

        packages = {
          inherit (self.packages.${system}.gradle2nix) gradleSetupHook;
          gradle2nix = pkgs.callPackage ./default.nix { };
          default = self.packages.${system}.gradle2nix;
        };

        apps = rec {
          gradle2nix = {
            type = "app";
            program = lib.getExe self.packages.${system}.default;
          };

          default = gradle2nix;
        };

        formatter = pkgs.writeShellScriptBin "gradle2nix-fmt" ''
          fail=0
          ${lib.getExe pkgs.nixfmt-rfc-style} $@ || fail=1
          ${lib.getExe pkgs.git} ls-files -z '*.kt' '*.kts' | ${lib.getExe pkgs.ktlint} --relative -l warn -F --patterns-from-stdin= || fail=1
          [ $fail -eq 0 ] || echo "Formatting failed." >&2
          exit $fail
        '';
      }
    );
}
