{
  lib,
  stdenvNoCC,
  runCommand,
  fetchFromGitLab,
# nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "renere-spinny-blobs";
  version = "0-unstable-2023-12-23";

  src = fetchFromGitLab {
    owner = "renere";
    repo = "spinny_blobs";
    rev = "419cf7120cf010f4a292b74e2a585b79e3b8aab8";
    hash = "sha256-koXRmXmgNfJj4HdAsG1pXA2HXxK5MqrCrqKpZ4YZg3Y=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp render/{cat,fox}/trimmed/*.gif $out

    runHook postInstall
  '';

  passthru = {
    onlyBlobcats =
      runCommand "renere-spinny-blobcats"
        {
          inherit (finalAttrs) version;

          meta = finalAttrs.meta // {
            description = finalAttrs.meta.description + " (blobcats only)";
          };
        }
        ''
          mkdir -p $out
          cp ${finalAttrs.finalPackage}/spinny_cat*.gif $out
        '';

    onlyBlobfoxes =
      runCommand "renere-spinny-blobfoxes"
        {
          inherit (finalAttrs) version;

          meta = finalAttrs.meta // {
            description = finalAttrs.meta.description + " (blobfoxes only)";
          };
        }
        ''
          mkdir -p $out
          cp ${finalAttrs.finalPackage}/spinny_fox*.gif $out
        '';

    # updateScript = nix-update-script {
    #   extraArgs = [
    #     "--version"
    #     "branch"
    #   ];
    # };
  };

  meta = {
    description = "these are the spinny (pride) blobs of life";
    homepage = "https://gitlab.com/renere/spinny_blobs";
    license = lib.licenses.unfree; # TODO: ?
    platforms = lib.platforms.all;
    # maintainers = [ lib.maintainers.federicoschonborn ];
  };
})
