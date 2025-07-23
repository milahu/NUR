{
  pkgs,
  config,
  lib,
  ...
}:
let
  pythEscape = x: builtins.replaceStrings [ ''"'' "\n" "\\" ] [ ''\"'' "\\n" "\\\\" ] x;
  pythonScript = builtins.replaceStrings [ "@sops@" "@dns_secrets_file@" "@data@" ] (map pythEscape [
    (lib.getExe config.vacu.wrappedSops)
    (builtins.toString ../../secrets/misc/cloudns.json)
    (builtins.toJSON config.vacu.dns)
  ]) (builtins.readFile ./script.py);
  libraries = with pkgs.python3Packages; [
    httpx
    dnspython
  ];
  python = pkgs.python312.withPackages (_: libraries);
in
(pkgs.writers.writePython3Bin "dns-update" { inherit libraries; } pythonScript).overrideAttrs
  (old: {
    passthru = (old.passthru or { }) // {
      inherit libraries python;
    };
  })
