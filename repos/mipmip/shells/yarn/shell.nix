with (import <nixpkgs> {});

mkShell {
  buildInputs = [
    nodejs
  ];
  shellHook = ''
  '';
}

