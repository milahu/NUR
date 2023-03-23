{ pkgs, nodejs, stdenv, lib, ... }:

let

  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./package.json));
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages."${packageName}".override {
  nativeBuildInputs = [ pkgs.makeWrapper ];

  meta = with lib; {
    description = "Compile a Frida script comprised of one or more Node.js modules";
    homepage = https://github.com/frida/frida-compile;
    maintainers = with maintainers; [ genesis ];
    license = licenses.wxWindows; # "LGPL-2.0 WITH WxWindows-exception-3.1"
    platforms = platforms.linux;
  };
}
