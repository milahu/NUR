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
, gnuapl
}:

stdenv.mkDerivation rec {
  pname   = "cowsaypl";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "ona-li-toki-e-jan-Epiphany-tawa-mi";
    repo  = "cowsAyPL";
    rev   = "RELEASE-V${version}";
    hash  = "sha256-KUSFKXIUFh9Qu0lyqfHJI26DDkPeRw5gkXYC56UClYo=";
  };

  doCheck     = true;
  checkInputs = [ gnuapl ];
  checkPhase  = ''
    runHook preCheck

    apl --script test.apl -- test tests/sources tests/outputs

    runHook postCheck
  '';

  buildInputs  = [ gnuapl ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp cowsay.apl "$out/bin/${pname}"

    mkdir -p "$out/lib"
    cp workspaces/fio.apl "$out/lib"
    sed -e "s|)COPY_ONCE fio.apl|)COPY_ONCE $out/lib/fio.apl|" \
        -e 's|⊣ ⍎")COPY_ONCE logging.apl"||'                   \
        -i "$out/bin/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cowsay in GNU APL";
    homepage    =
      "https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/cowsAyPL";
    license     = licenses.gpl3Plus;
    mainProgram = pname;
  };
}
