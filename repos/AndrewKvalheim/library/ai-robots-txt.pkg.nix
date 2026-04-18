{ fetchFromGitHub
, gitUpdater
, lib
, stdenv
}:

stdenv.mkDerivation (ai-robots-txt: {
  pname = "ai-robots-txt";
  version = "1.45";

  src = fetchFromGitHub {
    owner = "ai-robots-txt";
    repo = "ai.robots.txt";
    rev = "refs/tags/v${ai-robots-txt.version}";
    hash = "sha256-HwRsZKQlK0t88Sz7VDQ5qZoufPTfYofZhBQ6EY3jVkg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/share/ai-robots-txt"
    cp --target-directory "$out/share/ai-robots-txt" \
      '.htaccess' \
      'Caddyfile' \
      'haproxy-block-ai-bots.txt' \
      'nginx-block-ai-bots.conf' \
      'robots.json' \
      'robots.txt'

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "List of AI agents and robots to block";
    homepage = "https://github.com/ai-robots-txt/ai.robots.txt";
    license = lib.licenses.mit;
  };
})
