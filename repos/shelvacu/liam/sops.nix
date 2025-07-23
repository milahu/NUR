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
    defaultSopsFile = config.vacu.secretsFolder + "/liam/main.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.dovecot-passwd = {
      restartUnits = [ "dovecot2.service" ];
    };
    secrets.dkim_key = {
      name = "dkimkeys/2024-03-liam.private";
      restartUnits = [ "opendkim.service" ];
      owner = config.services.opendkim.user;
    };
    secrets.relay_creds = {
      restartUnits = [ "postfix.service" ];
      owner = config.services.postfix.user;
    };
    gnupg.sshKeyPaths = [ ]; # explicitly empty to disable gnupg; I don't use it and it takes up space on minimal configs
  };
}
