{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.vacu.secretsFolder = lib.mkOption {
    type = lib.types.path;
    default = ../secrets;
  };

  config = {
    sops.defaultSopsFile = config.vacu.secretsFolder + "/triple-dezert/main.yaml";
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # sops.secrets.vacustore_smtp_key = {};
  };
}
