# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage
{pkgs ? import <nixpkgs> {}}: {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib {inherit pkgs;}; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  fcitx5-tokyonight = pkgs.callPackage ./pkgs/fcitx5-tokyonight {};
  hanyi-wenhei = pkgs.callPackage ./pkgs/hanyi-wenhei {};
  hanyi-wenhei-genshin = pkgs.callPackage ./pkgs/hanyi-wenhei-genshin {};
  harmonyos-sans = pkgs.callPackage ./pkgs/harmonyos-sans {};
  metacubexd = pkgs.callPackage ./pkgs/metacubexd {};
  misans = pkgs.callPackage ./pkgs/misans {};
  picom-ft-labs = pkgs.callPackage ./pkgs/picom-ft-labs {};
  telegram-swift-bin = pkgs.callPackage ./pkgs/telegram-swift-bin {};
  v2ray-rules-dat = pkgs.callPackage ./pkgs/v2ray-rules-dat {};
}
