# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  mesonlsp-bin = {
    pname = "mesonlsp-bin";
    version = "v4.3.3";
    src = fetchurl {
      url = "https://github.com/JCWasmx86/mesonlsp/releases/download/v4.3.3/mesonlsp-x86_64-unknown-linux-musl.zip";
      sha256 = "sha256-J51tEvym1xAr5XuVvjgD7uvu+ADG4x2HG3cd19X8mpk=";
    };
  };
}
