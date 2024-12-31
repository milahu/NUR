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
, zig_0_13
}:

stdenv.mkDerivation rec {
  pname   = "love-you-mom";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ona-li-toki-e-jan-Epiphany-tawa-mi";
    repo  = "love-you-mom";
    rev   = version;
    hash  = "sha256-XRPi0FEkjaUVYOXbYjhwf0acANiLZ5pybQiFnpV09m4=";
  };

  nativeBuildInputs = [ zig_0_13.hook ];
  zigBuildFlags     = [ "-Doptimize=ReleaseSafe" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp zig-out/bin/love-you-mom "$out/bin/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description =
      "Tells your mom (or dad) that you love them";
    homepage =
      "https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/love-you-mom";
    license     = licenses.gpl3Plus;
    mainProgram = pname;
  };
}
