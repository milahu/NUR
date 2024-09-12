{ lib, pkgs, ... }:
pkgs.python3Packages.buildPythonApplication rec {
  pname = "together-cli";
  version = "0.2.11";
  propagatedBuildInputs = [
    pkgs.python3Packages.aiohttp
    pkgs.python3Packages.pydantic
    pkgs.python3Packages.requests
    pkgs.python3Packages.sseclient-py
    pkgs.python3Packages.tabulate
    pkgs.python3Packages.tqdm
    pkgs.python3Packages.typer
  ];
  doCheck = false;

  src = pkgs.fetchzip rec{
    url = "https://https://fly.storage.tigris.dev/public/together-0.2.11.tar.gz";
    sha256 = "sha256-aMuGmJAJybBtTaRruj8yMe80mIpIF19r4xW6BgrhV30=";
  };

}
