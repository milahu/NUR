{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.vacu.secretsFolder = lib.mkOption {
    type = lib.types.path;
    default = ../secrets;
  };

  config.sops = {
    defaultSopsFile = config.vacu.secretsFolder + "/prophecy/main.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
