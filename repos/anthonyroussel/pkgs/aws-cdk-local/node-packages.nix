# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "diff-5.1.0" = {
      name = "diff";
      packageName = "diff";
      version = "5.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/diff/-/diff-5.1.0.tgz";
        sha512 = "D+mk+qE8VC/PAUrlAU34N+VfXev0ghe5ywmpqrawphmVZc1bEfn56uo9qpyGp1p4xpzOHkSW4ztBd6L7Xx4ACw==";
      };
    };
  };
in
{
  aws-cdk-local = nodeEnv.buildNodePackage {
    name = "aws-cdk-local";
    packageName = "aws-cdk-local";
    version = "2.18.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/aws-cdk-local/-/aws-cdk-local-2.18.0.tgz";
      sha512 = "ZNQxs4GKHG2MC5y19MJZE/Xf/c0tAdjH6LWbZdouyG4k+1DeuFtBZ+UoYjoUfGPI8dycGpwUiewsLBY1lbtTWg==";
    };
    dependencies = [
      sources."diff-5.1.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "CDK Toolkit for use with LocalStack";
      homepage = "https://github.com/localstack/aws-cdk-local#readme";
      license = "Apache-2.0";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}