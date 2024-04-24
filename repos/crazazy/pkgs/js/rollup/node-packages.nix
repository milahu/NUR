# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@types/estree-1.0.5" = {
      name = "_at_types_slash_estree";
      packageName = "@types/estree";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/estree/-/estree-1.0.5.tgz";
        sha512 = "/kYRxGDLWzHOB7q+wtSUQlFrtcdUccpfy+X+9iMBpHK8QLLhx2wIPYuS5DYtR9Wa/YlZAbIovy7qVdB1Aq6Lyw==";
      };
    };
  };
  args = {
    name = "rollup";
    packageName = "rollup";
    version = "4.16.4";
    src = fetchurl { url = "https://registry.npmjs.org/rollup/-/rollup-4.16.4.tgz"; sha1 = "fe328eb41293f20c9593a095ec23bdc4b5d93317"; };
    dependencies = [
      sources."@types/estree-1.0.5"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Next-generation ES module bundler";
      homepage = "https://rollupjs.org/";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
in
{
  args = args;
  sources = sources;
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
  nodeDependencies = nodeEnv.buildNodeDependencies (lib.overrideExisting args {
    src = stdenv.mkDerivation {
      name = args.name + "-package-json";
      src = nix-gitignore.gitignoreSourcePure [
        "*"
        "!package.json"
        "!package-lock.json"
      ] args.src;
      dontBuild = true;
      installPhase = "mkdir -p $out; cp -r ./* $out;";
    };
  });
}
