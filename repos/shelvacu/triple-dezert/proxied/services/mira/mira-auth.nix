{ ... }:
let
  port = 8443;
  domain = "auth.for.miras.pet";
in
{
  vacu.proxiedServices.mira-auth = {
    inherit domain port;
    fromContainer = "mira-auth";
    forwardFor = true;
    useSSL = true;
    maxConnections = 100;
  };

  containers.mira-auth = {
    privateNetwork = true;
    hostAddress = "192.168.100.38";
    localAddress = "192.168.100.39";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;

    config =
      { pkgs, lib, ... }:
      let
        certtool = "${pkgs.gnutls.bin}/bin/certtool";
        template_text = ''
          organization = "Foobar"
          country = GR
          cn = "localhost"
          signing_key
          encryption_key
          tls_www_server
        '';
        template_file = pkgs.writeText "selfsigned-template" template_text;
        cert_dir = "/kanidm-certs";
        cert_chain = "${cert_dir}/chain.pem";
        cert_key = "${cert_dir}/key.pem";
      in
      {
        system.stateVersion = "24.11";

        networking.firewall.enable = false;
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;

        systemd.tmpfiles.settings."10-kanidm" = {
          ${cert_dir}.d = {
            mode = "0700";
            user = "kanidm";
            group = "kanidm";
          };
        };

        systemd.services.make-kanidm-self-signed-cert = {
          script = ''
            if [[ ! -f ${lib.escapeShellArg cert_chain} ]]; then
              ${certtool} --generate-privkey --outfile=${lib.escapeShellArg cert_key} --key-type=rsa --sec-param=high
              ${certtool} --generate-self-signed --load-privkey=${lib.escapeShellArg cert_key} --outfile=${lib.escapeShellArg cert_chain} --template=${lib.escapeShellArg template_file}
            fi
          '';
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "kanidm";
            Group = "kanidm";
          };
        };

        systemd.services.kanidm.unitConfig = {
          Requires = [ "make-kanidm-self-signed-cert.service" ];
          After = [ "make-kanidm-self-signed-cert.service" ];
        };

        services.kanidm = {
          package = pkgs.kanidm_1_6;
          enableServer = true;
          enableClient = true;
          clientSettings = {
            uri = "https://localhost:${toString port}";
            verify_hostnames = false;
            verify_ca = false;
          };
          serverSettings = {
            bindaddress = "[::]:${toString port}";
            inherit domain;
            origin = "https://${domain}";
            trust_x_forward_for = true;
            tls_chain = cert_chain;
            tls_key = cert_key;
          };
        };
      };
  };
}
