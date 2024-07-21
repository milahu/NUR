{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
# nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "renere-spinny-blobs";
  version = "0-unstable-2023-12-23";

  outputs = [
    "out"
    "blobcatsOnly"
    "blobfoxesOnly"
  ];

  src = fetchFromGitLab {
    owner = "renere";
    repo = "spinny_blobs";
    rev = "419cf7120cf010f4a292b74e2a585b79e3b8aab8";
    hash = "sha256-koXRmXmgNfJj4HdAsG1pXA2HXxK5MqrCrqKpZ4YZg3Y=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out $blobcatsOnly $blobfoxesOnly
    cp render/{cat,fox}/trimmed/*.gif $out
    cp render/cat/trimmed/*.gif $blobcatsOnly
    cp render/fox/trimmed/*.gif $blobfoxesOnly

    runHook postInstall
  '';

  passthru = {
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
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
