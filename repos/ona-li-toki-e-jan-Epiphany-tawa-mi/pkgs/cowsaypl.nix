# MIT License
#
# Copyright (c) 2024-2025 ona-li-toki-e-jan-Epiphany-tawa-mi
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
, fetchgit
, lib
, gnuapl
}:

stdenv.mkDerivation rec {
  pname   = "cowsaypl";
  version = "2.0.0";

  src = fetchgit {
    url  = "https://paltepuk.xyz/cgit/cowsAyPL.git";
    rev  = version;
    hash = "sha256-FkKkChXtnMNPQDhr09/65Wl7eR91XRzN2xM6vdc8CcM=";
  };

  doCheck     = true;
  checkInputs = [ gnuapl ];
  checkPhase  = ''
    runHook preCheck

    apl --script test.apl --

    runHook postCheck
  '';

  buildInputs  = [ gnuapl ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    cp workspaces/fio.apl "$out/lib"

    mkdir -p "$out/bin"
    substituteInPlace cowsay.apl --replace-fail     \
                      ')COPY_ONCE fio.apl'          \
                      ")COPY_ONCE $out/lib/fio.apl"
    cp cowsay.apl "$out/bin/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cowsay in GNU APL";
    homepage    = "https://paltepuk.xyz/cgit/cowsAyPL.git/about";
    license     = licenses.gpl3Plus;
    mainProgram = pname;
  };
}
