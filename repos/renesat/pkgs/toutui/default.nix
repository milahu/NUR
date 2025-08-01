{
  fetchFromGitHub,
  rustPlatform,
  lib,
  pkg-config,
  openssl,
  sqlite,
}:
rustPlatform.buildRustPackage rec {
  pname = "toutui";
  version = "0.3.3-beta";

  src = fetchFromGitHub {
    owner = "AlbanDAVID";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-0ApaeBDo9xw8bKmUpbfLmWOKs1aXUkcMEitskLMhujg=";
  };

  cargoHash = "sha256-MTWUr1lsz/JGN8uKqHpzV9wLk44zcYlbQLeAgGWHhOY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  meta = {
    description = "Toutui is a TUI Audiobookshelf Client for Linux";
    homepage = "https://github.com/AlbanDAVID/Toutui";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [renesat];
  };
}
