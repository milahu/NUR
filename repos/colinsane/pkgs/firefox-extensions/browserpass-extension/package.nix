{
  fetchFromGitHub,
  fetchYarnDeps,
  gitUpdater,
  mkYarnModules,
  nodejs,
  stdenvNoCC,
  wrapFirefoxAddonsHook,
  zip,
}:

let
  pname = "browserpass-extension";
  version = "3.9.0";
  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-extension";
    rev = version;
    hash = "sha256-FRFW67SNPXWk/OHYsHLDSXCHlCjTVnOulNx/oVnYvAE=";
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
    packageJSON = "${src}/src/package.json";
    # XXX(2025-12-14): this triggers IFD, but NUR & system configs *seem* to be OK with that??
    yarnLock = "${src}/src/yarn.lock";
    # offlineCache = fetchYarnDeps {
    #   yarnLock = "${src}/src/yarn.lock";
    #   # yarnLock = ./yarn.lock;
    #   hash = "sha256-8cKFbrY3EcQBCnwJHFgPCL7HZnM6w4edwkkibMLVyRQ=";
    # };
  };
in stdenvNoCC.mkDerivation {
  inherit pname src version;

  nativeBuildInputs = [
    nodejs
    wrapFirefoxAddonsHook
    zip
  ];

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
    mkdir $out
    zip -r $out/$extid.xpi ./*
    popd
  '';

  extid = "browserpass@maximbaz.com";
  keepFirefoxPermissions = [
    "activeTab"
    "alarms"
    "tabs"
    "clipboardRead"
    "clipboardWrite"
    "nativeMessaging"
    # "notifications"  #< remove `notifications` perm, else it spams info for where to file bug reports, etc, on first launch
    "webRequest"
    "webRequestBlocking"
    "http://*/*"
    "https://*/*"
  ];

  passthru = {
    yarn-modules = browserpass-extension-yarn-modules;
    updateScript = gitUpdater { };
  };
}
