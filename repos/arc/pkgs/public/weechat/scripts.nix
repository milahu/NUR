{
  # https://weechat.org/scripts/
  auto_away = { buildWeechatScript }: buildWeechatScript {
    pname = "auto_away.py";
    version = "0.4";
    sha256 = "02my55fz9cid3zhnfdn0xjjf3lw5cmi3gw3z3sm54yif0h77jwbn";
  };
  autoconf = { buildWeechatScript }: buildWeechatScript {
    pname = "autoconf.py";
    version = "0.4";
    sha256 = "122krj58hvsn7z6221ra7f1l5h6xa4g0dsdsrxzwkvkq83j01f00";
  };
  emoji = { buildWeechatScript }: buildWeechatScript {
    pname = "emoji.lua";
    version = "5";
    sha256 = "072ampdhvvmah5hjc2raxvgjx632mmqa1j42sf3jabh0q4ha52ps";
  };
  parse_relayed_msg = { buildWeechatScript }: buildWeechatScript {
    pname = "parse_relayed_msg.pl";
    version = "1.9.7";
    sha256 = "sha256-Q9CWSfEkDe1H0ncuJVcede5q8UtaqroYHHin9IlsJgY=";
  };
  title = { buildWeechatScript }: buildWeechatScript {
    pname = "title.py";
    version = "0.9";
    sha256 = "1h8mxpv47q3inhynlfjm3pdjxlr2fl06z4cdhr06kpm8f7xvz56p";
  };
  unread_buffer = { buildWeechatScript }: buildWeechatScript {
    pname = "unread_buffer.py";
    version = "2";
    sha256 = "0xrds576lvvbbimg9zl17s62zg0nyymv4qnjsbjx770hcwbbyp2s";
  };
  urlgrab = { buildWeechatScript }: buildWeechatScript {
    pname = "urlgrab.py";
    version = "3.2";
    sha256 = "sha256-9sRgwQl55VLs/FvgfLc16+nNrvoxlRvmwuurV33S6hc=";
    patches = [
      ./urlgrab-homedir.patch
    ];
  };
  vimode = { buildWeechatScript }: buildWeechatScript {
    pname = "vimode.py";
    version = "0.8.1";
    sha256 = "1nz0y4w1r0whcrsqrwk6vc6f1lz62qkph5i445zjdgqy98x1v9bf";
  };
  vimode-develop = { fetchFromGitHub, stdenvNoCC, fetchurl }: stdenvNoCC.mkDerivation rec {
    pname = "vimode.py";
    version = "2021-03-13";
    rev = "897a33b9fb28c98c4e0a1c292d13536dd57f85c7";
    src = fetchFromGitHub {
      owner = "GermainZ";
      repo = "weechat-vimode";
      rev = rev;
      sha256 = "1mg6j2iwlg8y0ys7zy7vl2q6hk4hg5nqir02z26n2pg33rfb3hmm";
    };

    patches = let
      fixrev = "d67f36d01890b042f084e60f4f3b61e0803ada5b";
      sha256 = "sha256-IIiaMDd4eSag2MGcpmOy5A97kZ/f4xXfI0EEHeh5TrA=";
    in [ (fetchurl {
      name = "weechat-vimode-arc.patch";
      url = "https://github.com/GermainZ/weechat-vimode/compare/GermainZ:${rev}...arcnmx:${fixrev}.diff";
      inherit sha256;
    }) ];

    installPhase = ''
      install -Dt $out/share vimode.py
    '';

    passthru.scripts = [ pname ];
  };
  weechat-matrix = { python3Packages, weechat-matrix }: python3Packages.weechat-matrix or weechat-matrix;
}
