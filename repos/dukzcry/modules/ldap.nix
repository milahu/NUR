{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.ldap;
in {
  config = {
    services.grafana.settings = {
      "auth.ldap" = {
        enabled = true;
        config_file = toString ((pkgs.formats.toml { }).generate "ldap.toml" ({
          servers = [{
            host = "localhost";
            port = 3890;
            bind_dn = "uid=%s,ou=people,dc=example,dc=com";
            search_filter = "(uid=%s)";
            search_base_dns = ["dc=example,dc=com"];
            attributes = {
              member_of = "memberOf";
              email = "mail";
              name = "displayName";
              surname = "sn";
              username = "uid";
            };
            group_mappings = [
              { group_dn = "cn=lldap_admin,ou=groups,dc=example,dc=com"; org_role = "Admin"; grafana_admin = true; }
              { group_dn = "cn=lldap_password_manager,ou=groups,dc=example,dc=com"; org_role = "Editor"; }
            ];
          }];
        }));
      };
    };
    services.syncthing.settings = {
      gui = {
        authMode = "ldap";
      };
      ldap = {
        address = "localhost:3890";
        bindDN = "cn=%s,ou=people,dc=example,dc=com";
      };
    };
    services.open-webui.environment = {
      ENABLE_LDAP = "True";
      LDAP_SERVER_LABEL = "LDAP Server";
      LDAP_SERVER_HOST = "robocat";
      LDAP_SERVER_PORT = "3890";
      LDAP_ATTRIBUTE_FOR_USERNAME = "uid";
      LDAP_APP_DN = "uid=admin,ou=people,dc=example,dc=com";
      LDAP_SEARCH_BASE = "ou=people,dc=example,dc=com";
      LDAP_SEARCH_FILTER = "(uid=*)";
      LDAP_USE_TLS = "False";
    };
  };
}
