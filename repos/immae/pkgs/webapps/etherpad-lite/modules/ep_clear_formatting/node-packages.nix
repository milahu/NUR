# This file has been generated by node2nix 1.6.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, globalBuildInputs ? []}:

let
  sources = {};
in
{
  ep_clear_formatting = nodeEnv.buildNodePackage {
    name = "ep_clear_formatting";
    packageName = "ep_clear_formatting";
    version = "0.0.2";
    src = fetchurl {
      url = "https://registry.npmjs.org/ep_clear_formatting/-/ep_clear_formatting-0.0.2.tgz";
      sha1 = "b16970b9c6be01246d23cb5a81777aa220d06fc4";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "Clear formatting on a selection, this plugin requires the file menu";
    };
    production = true;
    bypassCache = false;
  };
}