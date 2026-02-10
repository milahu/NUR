{
  _experimental-update-script-combinators,
  curl,
  fetchFromGitea,
  git,
  gnutar,
  lib,
  nix-update-script,
  sqlite,
  stdenvNoCC,
  writeShellApplication,
}:

stdenvNoCC.mkDerivation {
  pname = "podcastindex-db";
  version = "0-unstable-2026-02-08";

  src = fetchFromGitea {
    domain = "git.uninsane.org";
    owner = "colin";
    repo = "podcastindex-db-mirror";
    rev = "332d2e5972ee332896debac234e5566f3a03532c";
    hash = "sha256-USot+MFM+YpXHxwBYZaxMBaEElJoW6b8ZUJGozVX+r8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/podcastindex
    cp podcastindex_feeds.csv $out/share/podcastindex

    runHook postInstall
  '';

  passthru = rec {
    updateNixFromMirror = nix-update-script {
      extraArgs = [ "--version" "branch" ];
    };
    mirror-update-script = writeShellApplication {
      name = "mirror-update-script";
      runtimeInputs = [
        curl
        git
        gnutar
        sqlite
      ];
      text = ''
        set -ex
        CHECKOUT_DIR=$(mktemp -d podcastindex.XXXXXXXX --tmpdir)
        pushd "$CHECKOUT_DIR"

        git clone git@git.uninsane.org:colin/podcastindex-db-mirror.git
        cd podcastindex-db-mirror
        ./update

        git push origin master

        popd
        rm -rf "$CHECKOUT_DIR"
      '';
    };
    updateMirrorFromUpstream = lib.getExe mirror-update-script;
    updateScript = _experimental-update-script-combinators.sequence [
      updateMirrorFromUpstream
      updateNixFromMirror
    ];
  };

  meta = with lib; {
    description = "csv database of 800k+ known public podcasts";
    homepage = "https://podcastindex.org";
    maintainers = with maintainers; [ colinsane ];
  };
}
