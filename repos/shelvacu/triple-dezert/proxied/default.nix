{
  imports = [
    ./frontproxy.nix
    ./options.nix
    ./services
  ];

  vacu.proxiedServices = {
    habitat.enable = true;
    vacustore.enable = true;
    jl-stats.enable = true;
    nix-cache.enable = true;
    static-stuff-tulpaudcast.enable = true;
    static-stuff-mira.enable = true;
    static-stuff-gab.enable = true;
    llm.enable = true;
    dufs.enable = true;
    jobs.enable = true;
    rad.enable = true;
    mira-auth.enable = true;
    vaultwarden.enable = true;
    mira-git.enable = true;
    mira-wisdom.enable = true;
    mira-chat.enable = true;

    keycloak.enable = false;
    kanidm.enable = false;
    jellyfin.enable = false;
  };
}
