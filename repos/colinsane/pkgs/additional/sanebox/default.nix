{ lib, stdenv
, bash
, bubblewrap
, firejail
, landlock-sandboxer
, libcap
, substituteAll
, profileDir ? "/share/sanebox/profiles"
}:

let
  sanebox = substituteAll {
    src = ./sanebox;
    inherit bash bubblewrap firejail libcap;
    landlockSandboxer = landlock-sandboxer;
    firejailProfileDirs = "/run/current-system/sw/etc/firejail /etc/firejail ${firejail}/etc/firejail";
  };
  self = stdenv.mkDerivation {
    pname = "sanebox";
    version = "0.1";

    src = sanebox;
    dontUnpack = true;

    buildPhase = ''
      runHook preBuild
      substituteAll "$src" sanebox \
        --replace-fail '@out@' "$out"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -d "$out"
      install -d "$out/bin"
      install -m 755 sanebox $out/bin/sanebox
      runHook postInstall
    '';

    passthru = {
      inherit landlock-sandboxer;
      withProfiles = profiles: self.overrideAttrs (base: {
        inherit profiles;
        postInstall = (base.postInstall or "") + ''
          install -d $out/share/sanebox
          ln -s "${profiles}/${profileDir}" "$out/${profileDir}"
        '';
      });
    };

    meta = {
      description = ''
        helper program to run some other program in a sandbox.
        factoring this out allows:
        1. to abstract over the particular sandbox implementation (bwrap, firejail, ...).
        2. to modify sandbox settings without forcing a rebuild of the sandboxed package.
      '';
      mainProgram = "sanebox";
    };
  };
in self
