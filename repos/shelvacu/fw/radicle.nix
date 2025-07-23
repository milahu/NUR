{ config, ... }:
{
  sops.secrets.radicle-key = {
    sopsFile = ../secrets/radicle-private.key;
    format = "binary"; # its actually an openssh private key which is kinda plaintext, but there is no plaintext option and treating it as opaque binary works fine
  };
  services.radicle = {
    enable = false;
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2HqXfjT4vPEqqM5Pty7EuswzeO80IgG6MtCvDAqOkD";
    privateKeyFile = config.sops.secrets.radicle-key.path;
    settings = {
      node.alias = "shelvacu-fw";
      seedingPolicy.default = "block";
    };
  };
}
