# This file has been generated by node2nix 1.6.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, globalBuildInputs ? []}:

let
  sources = {};
in
{
  ep_font_size = nodeEnv.buildNodePackage {
    name = "ep_font_size";
    packageName = "ep_font_size";
    version = "0.1.11";
    src = fetchurl {
      url = "https://registry.npmjs.org/ep_font_size/-/ep_font_size-0.1.11.tgz";
      sha1 = "997c079bab97e04196c9db43b3bb238c804d8126";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "Add support for Font Sizes";
    };
    production = true;
    bypassCache = false;
  };
}