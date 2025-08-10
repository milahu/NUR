{ rustPlatform }:

rustPlatform.buildRustPackage (filter-imf: {
  pname = "filter-imf";
  version = "1.0.0";

  src = fetchGit {
    url = ~/akorg/project/current/filter-imf/filter-imf;
    ref = "v${filter-imf.version}";
  };

  cargoHash = "sha256-3hE2N7e1K+RwZj4x4cubGk/me/cQ8SzvA5TuKflEGUc=";

  meta = {
    mainProgram = "filter-imf";
  };
})
