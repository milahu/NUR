{ ... }:
{
  imports = [
    ./habitat-fwd.nix
    # ./jellyfin.nix
    ./jl-stats.nix
    # ./kanidm.nix
    # ./keycloak.nix
    ./llm.nix
    ./nix-cache-nginx.nix
    ./static-stuff.nix
    ./vacustore.nix
    ./dufs.nix
    ./jobs.nix
    ./radicle.nix
    ./mira
    ./vaultwarden.nix
    # intentionally excluding template.nix
  ];
}
