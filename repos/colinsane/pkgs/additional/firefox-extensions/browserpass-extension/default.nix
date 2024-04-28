{ stdenv
, fetchFromGitHub
, fetchFromGitea
, mkYarnModules
, nodejs
, zip
}:

let
  pname = "browserpass-extension";
  version = "3.8.0";
  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-extension";
    rev = version;
    hash = "sha256-7mGOqJh7TzaPLHoYoD6KD72xqaFR0+54Bi5VEHspwFE=";
  };
  # src = fetchFromGitea {
  #   domain = "git.uninsane.org";
  #   owner = "colin";
  #   repo = "browserpass-extension";
  #   # hack in sops support
  #   rev = "e3bf558ff63d002d3c15f2ce966071f04fada306";
  #   sha256 = "sha256-dSRZ2ToEOPhzHNvlG8qdewa7689gT8cNB7nXkN3/Avo=";
  # };
  browserpass-extension-yarn-modules = mkYarnModules {
    inherit version;
    pname = "${pname}-modules";
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    # the following also works, but because it's IFD it's not allowed by some users, like NUR.
    # packageJSON = "${src}/src/package.json";
    # yarnLock = "${src}/src/yarn.lock";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ nodejs zip ];

  postPatch = ''
    # dependencies are built separately: skip the yarn install
    # prettier, lessc, browserify are made available here via the modules,
    # which are for the host (even the devDependencies are compiled for the host).
    # but we can just run those via the build node.
    #
    # alternative would be to patchShebangs in the node_modules dir.
    substituteInPlace src/Makefile \
      --replace-fail "yarn install" "true" \
      --replace-fail '	$(PRETTIER)' '	node $(PRETTIER)' \
      --replace-fail '	$(LESSC)' '	node $(LESSC)' \
      --replace-fail '	$(BROWSERIFY)' '	node $(BROWSERIFY)'
  '';

  preBuild = ''
    ln -s ${browserpass-extension-yarn-modules}/node_modules src/node_modules
  '';

  installPhase = ''
    pushd firefox
    zip -r $out ./*
    popd
  '';

  passthru = {
    yarn-modules = browserpass-extension-yarn-modules;
    extid = "browserpass@maximbaz.com";
  };
}
