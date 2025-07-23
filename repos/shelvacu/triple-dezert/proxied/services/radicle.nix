{ ... }:
let
  nodePort = 6794;
in
{
  vacu.proxiedServices.rad = {
    domain = "rad.shelvacu.com";
    fromContainer = "rad";
    port = 80;
    forwardFor = true;
    maxConnections = 100;
  };

  containers.rad = {
    privateNetwork = true;
    hostAddress = "192.168.100.36";
    localAddress = "192.168.100.37";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;

    forwardPorts = [
      {
        hostPort = nodePort;
        containerPort = nodePort;
      }
    ];

    config =
      { lib, ... }:
      {
        system.stateVersion = "24.11";

        networking.firewall.enable = false;
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;
        services.radicle = {
          enable = true;
          publicKey = "/var/lib/radicle/keys/radicle.pub";
          privateKeyFile = "/var/lib/radicle/keys/radicle";
          # publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2HqXfjT4vPEqqM5Pty7EuswzeO80IgG6MtCvDAqOkD";
          # privateKeyFile = config.sops.secrets.radicle-key.path;
          node.listenPort = nodePort;
          settings = {
            node.alias = "trip-seeder";
            node.externalAddresses = [
              "rad.shelvacu.com:${toString nodePort}"
              "powerhouse.shelvacu.com:${toString nodePort}"
            ];
            seedingPolicy.default = "block";
          };
          httpd = {
            enable = true;
            listenPort = 80;
            listenAddress = "[::]";
          };
        };
      };
  };
}
