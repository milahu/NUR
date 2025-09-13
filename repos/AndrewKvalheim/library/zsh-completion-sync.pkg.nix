{ fetchFromGitHub
, gitUpdater
, lib
, stdenv
}:

stdenv.mkDerivation (zsh-completion-sync: {
  pname = "zsh-completion-sync";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "BronzeDeer";
    repo = "zsh-completion-sync";
    rev = "v${zsh-completion-sync.version}";
    hash = "sha256-nTxeSUlYdl25MFZoLtpYTYq661iaik1RMj21ClOMY3c=";
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
