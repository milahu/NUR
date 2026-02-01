{ fetchzip }:

# TODO: meta, passthru.updateScript
let
  pname = "ai-robots-txt";
  version = "1.44";
in
fetchzip {
  name = "${pname}-${version}";
  url = "https://github.com/ai-robots-txt/ai.robots.txt/archive/refs/tags/v${version}.tar.gz";
  hash = "sha256-oOja8xrbpUIWdN+3+QcBszo2A7AxI+Le7KHoPKufTpI=";
}
