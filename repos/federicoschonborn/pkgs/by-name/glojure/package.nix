{
  lib,
  buildGoModule,
  fetchFromGitHub,
  clojure,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "glojure";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "glojurelang";
    repo = "glojure";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8cG7piZOaIK/yOav5SQ5t1ijzobhTSWl2VwsNbltDv8=";
  };

  vendorHash = "sha256-AIghWHfWocoY/6Yxu6cEtUmbembRaLtADmNaZiq+JHA=";

  nativeBuildInputs = [
    clojure
    writableTmpDirAsHomeHook
  ];

  strictDeps = true;

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Requires network access
        "FuzzCLJConformance/seed#2"
        "FuzzCLJConformance/seed#11"
        "FuzzCLJConformance/seed#12"
        # Runs go mod tidy, requires network access
        "TestGeneratedGo/try_advanced"
        "TestGeneratedGo/case_switch"
        "TestGeneratedGo/with_meta"
        "TestGeneratedGo/fn_closure"
        "TestGeneratedGo/ref"
        "TestGeneratedGo/quote_simple"
        "TestGeneratedGo/fn_recur"
        "TestGeneratedGo/the_var"
        "TestGeneratedGo/letfn"
        "TestGeneratedGo/maybe_class"
        "TestGeneratedGo/values"
        "TestGeneratedGo/set_bang"
        "TestGeneratedGo/throw_simple"
        "TestGeneratedGo/def_simple"
        "TestGeneratedGo/loop_simple"
        "TestGeneratedGo/try_basic"
        "TestGeneratedGo/multifn"
        "TestGeneratedGo/goroutine"
        # Fails on extra whitespace
        "TestCodegen/glojure.core"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "glj";
    description = "Clojure interpreter hosted on Go, with extensible interop support";
    homepage = "https://github.com/glojurelang/glojure";
    changelog = "https://github.com/glojurelang/glojure/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.epl10;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
