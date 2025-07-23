{
  lib,
  pkgs,
  config,
  vaculib,
  ...
}:
let
  inherit (builtins) head;
  ssh-to-age = lib.getExe pkgs.ssh-to-age;
  sshToAge =
    sshPubText:
    vaculib.outputOf {
      name = "age-from-ssh.txt";
      cmd = ''printf '%s' ${lib.escapeShellArg sshPubText} | ${ssh-to-age} > "$out"'';
    };
  userKeys = lib.attrValues config.vacu.ssh.authorizedKeys;
  userKeysAge = map sshToAge userKeys;
  liamKey = head config.vacu.hosts.liam.sshKeys;
  liamKeyAge = sshToAge liamKey;
  tripKey = head config.vacu.hosts.triple-dezert.sshKeys;
  tripKeyAge = sshToAge tripKey;
  propKey = head config.vacu.hosts.prophecy.sshKeys;
  propKeyAge = sshToAge propKey;
  singleGroup = keys: [ { age = keys; } ];
  testAgeSecret = "AGE-SECRET-KEY-1QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQPQQ94XCHF";
  testAgePublic = vaculib.outputOf {
    name = "test-age-public-key.txt";
    cmd = ''printf '%s' ${lib.escapeShellArg testAgeSecret} | ${pkgs.age}/bin/age-keygen -y > "$out"'';
  };
  sopsConfig = {
    creation_rules = [
      {
        path_regex = "/secrets/misc/[^/]+$";
        key_groups = singleGroup userKeysAge;
      }
      {
        path_regex = "/secrets/liam/[^/]+$";
        key_groups = singleGroup (userKeysAge ++ [ liamKeyAge ]);
      }
      {
        path_regex = "/secrets/triple-dezert/[^/]+$";
        key_groups = singleGroup (userKeysAge ++ [ tripKeyAge ]);
      }
      {
        path_regex = "/secrets/prophecy/[^/]+$";
        key_groups = singleGroup (userKeysAge ++ [ propKeyAge ]);
      }
      {
        path_regex = "/secrets/radicle-private.key$";
        key_groups = singleGroup (userKeysAge ++ [ (sshToAge (head config.vacu.hosts.fw.sshKeys)) ]);
      }
      {
        path_regex = "/tests/triple-dezert/test_secrets/";
        key_groups = singleGroup [ testAgePublic ];
      }
    ];
  };
  sopsConfigFile = pkgs.writers.writeYAML "sops.yaml" sopsConfig;
  wrappedSops = vaculib.makeWrapper {
    original = lib.getExe pkgs.sops;
    new = "vacu-nix-stuff-sops";
    add_flags = [
      "--config"
      sopsConfigFile
    ];
    run = lib.singleton ''
      set -e
      age_keys=("${testAgeSecret}" "$(cat $HOME/.ssh/id_ed25519 | ${lib.getExe pkgs.ssh-to-age} -private-key)")

      export SOPS_AGE_KEY
      printf -v SOPS_AGE_KEY "%s\n" "''${age_keys[@]}"
      # declare -p SOPS_AGE_KEY
    '';
  };
in
{
  options.vacu.sopsConfigFile = vaculib.mkOutOption sopsConfigFile;
  options.vacu.wrappedSops = vaculib.mkOutOption wrappedSops;
}
