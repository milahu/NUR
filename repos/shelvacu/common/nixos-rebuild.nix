{
  pkgs,
  config,
  lib,
  vacuModuleType,
  ...
}:
let
  nixos-rebuild = pkgs.nixos-rebuild.override { nix = config.nix.package.out; };
in
lib.optionalAttrs (vacuModuleType == "nixos") {
  options.vacu.alwaysUseRemoteSudo =
    (lib.mkEnableOption "always deploy to this machine with --use-remote-sudo")
    // {
      default = true;
    };
  config = lib.mkIf config.vacu.alwaysUseRemoteSudo {
    system.build.nixos-rebuild = lib.mkForce (
      pkgs.runCommandLocal "nixos-rebuild-wrapped"
        {
          nativeBuildInputs = [ pkgs.makeShellWrapper ];
          meta.mainProgram = "nixos-rebuild";
        }
        ''
          runHook preInstall

          mkdir -p "$out"/bin
          makeShellWrapper ${lib.getExe nixos-rebuild} "$out"/bin/nixos-rebuild --add-flags "--use-remote-sudo"

          runHook postInstall
        ''
    );
  };
}
