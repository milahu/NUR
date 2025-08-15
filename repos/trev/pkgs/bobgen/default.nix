{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bobgen";
  version = "0.40.1";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qqJ1d6lD61cP7NjtNuNHuc9NcB6g9HA+gG2voZGRP4E=";
  };

  vendorHash = "sha256-3K5ByPBrZRsLcmp0JMNLCcLqQdQizTdxN1Q7B4xe9vc=";

  subPackages = [
    "gen/bobgen-sql"
    "gen/bobgen-psql"
    "gen/bobgen-mysql"
    "gen/bobgen-sqlite"
  ];

  passthru = {
    unstable = callPackage ./unstable.nix {
      bobgen = finalAttrs.finalPackage;
    };
    updateScript = lib.concatStringsSep " " (nix-update-script {
      extraArgs = [
        "--commit"
        "${finalAttrs.pname}"
      ];
    });
  };

  meta = {
    description = "SQL query builder and ORM/Factory generator for Go";
    homepage = "https://github.com/stephenafamo/bob";
    changelog = "https://github.com/stephenafamo/bob/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
