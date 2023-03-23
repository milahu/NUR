{ stdenv, lib, callPackage, defaultCrateOverrides, CoreServices }:

(callPackage ./Cargo.nix { }).workspaceMembers.drep.build.override {
  crateOverrides = defaultCrateOverrides // {
    drep = attrs: {
      buildInputs = lib.optional stdenv.isDarwin CoreServices;
      meta = with lib; {
        description = "A grep with runtime reloadable filters";
        homepage = "https://github.com/maxpert/drep";
        license = licenses.mit;
        maintainers = with maintainers; [ AluisioASG ];
        platforms = platforms.all;
      };
    };
  };
}
