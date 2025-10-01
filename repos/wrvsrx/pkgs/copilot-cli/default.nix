{
  buildNpmPackage,
  source,
}:

buildNpmPackage {
  inherit (source) pname version src;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-u2lofopWa07/D+0n98Y63OhK0LaWmY5iEMGS6qQ/mEs=";

  dontNpmBuild = true;

  meta = {
    description = "GitHub Copilot CLI brings AI-powered coding assistance directly to your command line";
    homepage = "https://github.com/github/copilot-cli";
    license = "unfree"; # GitHub Pre-release License Terms
    mainProgram = "copilot";
  };
}
