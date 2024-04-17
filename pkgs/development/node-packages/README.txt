https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md



nixpkgs uses node2nix globally

  nixpkgs/pkgs/development/node-packages/node-packages.nix

and locally

  nixpkgs/pkgs/development/web/netlify-cli/node-packages.nix
  nixpkgs/pkgs/tools/security/onlykey/node-packages.nix
  nixpkgs/pkgs/applications/networking/n8n/node-packages.nix



some NUR repos use node2nix, either globally

  sagikazarmark/pkgs/node-packages/node-packages.nix
  yes/nodePackages/node-packages.nix
  mic92/pkgs/node-packages/node-packages.nix

or locally

  crazazy/pkgs/js/jspm/node-packages.nix
  crazazy/pkgs/js/typescript/node-packages.nix
  crazazy/pkgs/js/tern/node-packages.nix



https://discourse.nixos.org/t/future-of-npm-packages-in-nixpkgs/14285

If we are concerned about repository size
none of these approaches are really great
as node packages traditionally have tons of dependencies.



https://github.com/NixOS/nixpkgs/issues/14532

RFC: remove node packages
node-packages-generated.nix is utterly outdated
I guess this is no longer an issue by now.
