{ ... }:

{
  imports = [
    ./derived-secrets
    ./hosts.nix
    ./nixcache.nix
    ./roles
    ./services
    ./wg-home.nix
    ./yggdrasil.nix
  ];
}
