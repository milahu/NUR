# This file is generated by gradle2nix.
#
# Example usage (e.g. in default.nix):
#
#     with (import <nixpkgs> {});
#     let
#       buildGradle = callPackage ./gradle.nix {};
#     in
#       buildGradle {
#         lockFile = ./gradle.lock;
#
#         src = ./.;
#
#         gradleFlags = [ "installDist" ];
#
#         installPhase = ''
#           mkdir -p $out
#           cp -r app/build/install/myproject $out
#         '';
#       }

{
  lib,
  stdenv,
  gradle,
  buildMavenRepo,
  gradleSetupHook,
  writeText,
}:

{
  # Path to the lockfile generated by gradle2nix (e.g. gradle.lock).
  lockFile ? null,
  pname ? "project",
  version ? null,
  # The Gradle package to use. Default is 'pkgs.gradle'.
  gradlePackage ? gradle,
  # Override the default JDK used to run Gradle itself.
  buildJdk ? null,
  # Override functions which fetch dependency artifacts.
  # Names in this set are URL schemes such as "https" or "s3".
  # Values are functions which take a dependency in the form
  # `{ urls, hash }` and fetch into the Nix store. For example:
  #
  #   {
  #     s3 = { name, urls, hash }: fetchs3 {
  #       s3url = builtins.head urls;
  #       # TODO This doesn't work without patching fetchs3 to accept SRI hashes
  #       inherit name hash;
  #       region = "us-west-2";
  #       credentials = {
  #         access_key_id = "foo";
  #         secret_access_key = "bar";
  #       };
  #     };
  #   }
  fetchers ? { },
  # Override artifacts in the offline Maven repository.
  #
  # This is an attrset is of the form:
  #
  #   {
  #     "${group}:${module}:${version}" = {
  #       "${filename}" = <override function>;
  #     }
  #   }
  #
  # The override function takes the original derivation from 'fetchers' (e.g. the result of
  # 'fetchurl') and produces a new derivation to replace it.
  #
  # Examples:
  #
  # 1. Replace a dependency's JAR artifact:
  #
  #    {
  #      "com.squareup.okio:okio:3.9.0"."okio-3.9.0.jar" = _: fetchurl {
  #        url = "https://repo.maven.apache.org/maven2/com/squareup/okio/okio/3.9.0/okio-3.9.0.jar";
  #        hash = "...";
  #        downloadToTemp = true;
  #        postFetch = "install -Dt $out/com/squareup/okio/okio/3.9.0/ $downloadedFile"
  #      };
  #    }
  #
  # 2. Patch a JAR containing native binaries:
  #
  #    {
  #      "com.android.tools.build:aapt2:8.5.0-rc02-11315950" = {
  #        "aapt2-8.5.0-rc02-11315950-linux.jar" = src: runCommandCC src.name {
  #          nativeBuildInputs = [ jdk autoPatchelfHook ];
  #          dontAutoPatchelf = true;
  #        } ''
  #          cp ${src} aapt2.jar
  #          jar xf aapt2.jar aapt2
  #          chmod +x aapt2
  #          autoPatchelf aapt2
  #          jar uf aapt2.jar aapt2
  #          cp aapt2.jar $out
  #        '';
  #      }
  #    }
  overrides ? { },
  ...
}@args:

let
  inherit (builtins) removeAttrs;

  gradleSetupHook' = gradleSetupHook.overrideAttrs (_: {
    propagatedBuildInputs = [ gradlePackage ];
  });

  offlineRepo =
    if lockFile != null then buildMavenRepo { inherit lockFile fetchers overrides; } else null;

  buildGradlePackage = stdenv.mkDerivation (
    finalAttrs:
    {

      inherit buildJdk pname version;

      inherit (offlineRepo) gradleInitScript;

      dontStrip = true;

      nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ gradleSetupHook' ];

      gradleFlags =
        [ "--console=plain" ]
        ++ lib.optional (finalAttrs.buildJdk != null) "-Dorg.gradle.java.home=${finalAttrs.buildJdk.home}";

      passthru =
        lib.optionalAttrs (offlineRepo != null) { inherit offlineRepo; } // (args.passthru or { });
    }
    // removeAttrs args [
      "gradle"
      "gradleInitScript"
      "lockFile"
      "fetchers"
      "nativeBuildInputs"
      "overrides"
      "passthru"
    ]
  );
in
buildGradlePackage
