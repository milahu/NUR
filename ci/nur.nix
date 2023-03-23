{ buildPythonApplication, lib, nix-prefetch-git, git, nix, glibcLocales, requests }:

buildPythonApplication {
  name = "nur";
  src = ./.;

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  makeWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.makeBinPath [ nix-prefetch-git git nix ]}"
    "--set" "LOCALE_ARCHIVE" "${glibcLocales}/lib/locale/locale-archive"
  ];
}
