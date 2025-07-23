{ config, ... }:
{
  containers.mira-git.config =
    { lib, ... }:
    {
      services.forgejo.settings = {
        service = {
          DISABLE_REGISTRATION = lib.mkForce false;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          SHOW_REGISTRATION_BUTTON = false;
          ENABLE_INTERNAL_SIGNIN = false;
        };
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          USERNAME = "nickname";
          ACCOUNT_LINKING = "disabled";
          OPENID_CONNECT_SCOPES = "email profile groups";
        };
      };
    };
  containers.mira-auth.config =
    { pkgs, ... }:
    {
      # services.kanidm.package = pkgs.kanidm.withSecretProvisioning;
      services.kanidm.provision = {
        enable = false;
        # autoRemove = false;
        # groups.git_users = {
        #   present = true;
        #   members = [ "shelvacu" ];
        # };
        # systems.oauth2.${oauth_name} = {
        #   present = true;
        #   displayName = "Forgejo (git)";
        #   originUrl = "https://git.for.miras.pet/user/oauth2/Mira%20Cult%20SSO/callback";
        #   originLanding = "https://${git_domain}";
        #   # allowInsecureClientDisablePkce = true;
        #   public = false;
        #   scopeMaps.git_users = [ "email" "openid" "profile" "groups" ];
        #   preferShortUsername = true;
        # };
      };
    };
}
