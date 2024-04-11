{ lib, rustPlatform, fetchFromGitHub, ncurses }:

rustPlatform.buildRustPackage rec {
  pname = "stacklet";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ggemre";
    repo = pname;
    rev = version;
    sha256 = "0zfm4v6hnzjgcn8566frcixqz8y8w9k0yjhx8fvakyagnbscvvbk";
  };

  cargoSha256 = "sha256-bo3pemgeONf9vOfvEA9Up2TCKB655HAwVSZOpgG3LoE=";
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Generate custom applets and menus";
    longDescription = ''
      Stacklet is a powerful and versatile command-line tool written in Rust, designed to provide users with a seamless and interactive experience for managing various tasks and configurations in the terminal environment.
      The app features a scriptable architecture, allowing users to write scripts or provide instructions to automate tasks and customize the app's behavior.
      Users can navigate through custom applets and menus generated by the app, which dynamically adapt based on user input and external scripts/executables output.
    '';
    homepage = https://github.com/ggemre/stacklet;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
