{ buildGoModule
, fetchgit
, git
, go
, ffmpeg
, lib
}:

buildGoModule rec {
  pname   = "tube";
  version = "1.2.0";

  src = fetchgit {
    url         = "https://git.mills.io/prologic/${pname}";
    rev         = "${version}";
    hash        = "sha256-M+6sysUubbJl+BSqB71XDT/SQKvi3AOfeF6jLg71dWo=";
  };

  vendorHash  = "sha256-r6luOCnU08/7vGo7ryCcSgy1+IUqXNFpwwId8VhWPh0=";

  meta = with lib; {
    description = "A YouTube-like (without censorship and features you don't need!) Video Sharing App written in Go which also supports automatic transcoding to MP4 H.265 AAC, multiple collections and RSS feed";
    homepage    = "https://git.mills.io/prologic/tube";
    license     = licenses.mit;
    mainProgram = pname;
  };
}
