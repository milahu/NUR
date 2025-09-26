{ fetchFromGitHub
, gitUpdater
, lib
, stdenv
}:

stdenv.mkDerivation (zsh-completion-sync: {
  pname = "zsh-completion-sync";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "BronzeDeer";
    repo = "zsh-completion-sync";
    rev = "v${zsh-completion-sync.version}";
    hash = "sha256-GTW4nLVW1/09aXNnZJuKs12CoalzWGKB79VsQ2a2Av4=";
  };

  dontBuild = true;

  installPhase = ''
    install -D -t "$out/share/zsh/plugins/zsh-completion-sync" \
      'zsh-completion-sync.plugin.zsh'
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Zsh plugin that automatically loads completions added dynamically to FPATH or XDG_DATA_DIRS";
    homepage = "https://github.com/BronzeDeer/zsh-completion-sync";
    license = lib.licenses.asl20;
  };
})
