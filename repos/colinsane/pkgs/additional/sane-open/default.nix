{ static-nix-shell }:
static-nix-shell.mkBash {
  pname = "sane-open";
  srcRoot = ./.;
  pkgs = [ "glib" "jq" "procps" "sway" "util-linux" "xdg-utils" ];
}
