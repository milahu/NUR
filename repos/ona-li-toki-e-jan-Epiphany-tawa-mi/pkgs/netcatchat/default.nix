# MIT License
#
# Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

{ stdenv
, fetchFromGitHub
, lib
, netcat-openbsd
, shellcheck
}:

let sourceFile = "netcatchat.sh";
in
stdenv.mkDerivation rec {
  pname   = "netcatchat";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ona-li-toki-e-jan-Epiphany-tawa-mi";
    repo  = "netcatchat";
    rev   = "RELEASE-V${version}";
    hash  = "sha256-ST706XwdEUlcwXX9xtONkhzlFANybRgJxBVZdVnWoIo=";
  };

  doCheck     = true;
  checkInputs = [ shellcheck ];
  checkPhase  = ''
    runHook preCheck

    shellcheck "${sourceFile}"

    runHook postCheck
  '';

  nativeBuildInputs = [ netcat-openbsd ];
  installPhase      = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp "${sourceFile}" "$out/bin/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple command-line chat server and client using netcat";
    homepage    = "https://paltepuk.xyz/cgit/netcatchat.git/about";
    license     = licenses.mit;
    mainProgram = pname;
  };
}
