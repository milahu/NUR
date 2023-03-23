{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "HyFetch";
  version = "1.4.0";

  src = fetchFromGitHub {
    repo = "hyfetch";
    owner = "hykilpikonna";
    rev = version;
    sha256 = "sha256-15FeW3yaM7eUJ1O20H/bQquDRAsRWTJMzkzQ5Kv1ezE=";
  };

  # TODO: Remove with next release bump since it has been fixed upstream (hykilpikonna/hyfetch@d797a8c)
  postPatch = ''
    chmod +x neofetch
  '';

  propagatedBuildInputs = with python3Packages; [
    typing-extensions
    setuptools
  ];

  meta = with lib; {
    description = "neofetch with pride flags <3";
    longDescription = ''
      HyFetch is a command-line system information tool fork of neofetch.
      HyFetch displays information about your system next to your OS logo
      in ASCII representation. The ASCII representation is then colored in
      the pattern of the pride flag of your choice. The main purpose of
      HyFetch is to be used in screenshots to show other users what
      operating system or distribution you are running, what theme or
      icon set you are using, etc.
    '';
    homepage = "https://github.com/hykilpikonna/HyFetch";
    license = licenses.mit;
    mainProgram = "hyfetch";
    # maintainers = with maintainers; [ yisuidenghua ];
  };
}
