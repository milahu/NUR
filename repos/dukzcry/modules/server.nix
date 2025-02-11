{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.server;
in {
  options.services.server = {
    enable = mkEnableOption ''
      Support for my home server
    '';
    remote = mkEnableOption ''
      Support for remote use
    '';
  };

  config = mkMerge [
    (mkIf cfg.enable {
      system.fsPackages = with pkgs; [ sshfs ];
      systemd.mounts = [{
        type = "fuse.sshfs";
        what = "Artem@robocat:/data";
        where = "/data";
        options = "IdentityFile=/home/Artem/.ssh/id_rsa,allow_other,_netdev";
      }];
      systemd.automounts = [{
        wantedBy = [ "multi-user.target" ];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
        where = "/data";
      }];
      environment = {
        systemPackages = with pkgs; with pkgs.nur.repos.dukzcry; [
          jellyfin-media-player
        ];
      };
      systemd.sockets.cups.wantedBy = mkForce [];
      systemd.services.cups.wantedBy = mkForce [];
      services.printing = {
        enable = true;
        clientConf = ''
          ServerName robocat
        '';
      };
      security.pki.certificates = [
''
-----BEGIN CERTIFICATE-----
MIIFZDCCA0ygAwIBAgIUGAsc3X+PrQ2BwgmmLfQGfrF3suQwDQYJKoZIhvcNAQEL
BQAwHDEaMBgGA1UEAwwRcm9ib2NhdC5ob21lLmFycGEwIBcNMjUwMjEwMjMzMDM1
WhgPMjEyNTAyMTEyMzMwMzVaMBwxGjAYBgNVBAMMEXJvYm9jYXQuaG9tZS5hcnBh
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAoLfRm5lnLhiqtYVkX7IY
RvXXANuOgz2j3WV4z4EV3Gze7zvwXZATR7Gqsub5ES5mcYB2iiqtC8EomufD+rq/
Q0t27FX+JQMV+vnb12UqV/X/oFNm7MTxI2cy/i46jOauzf9+JIeCR1a2L9B7YPjO
IegcxOX+U9nbSaM7GqpKsKRJTdqZPm5gs0q5QAsfwpI4sm/BdKwmGw9YycM3NlFR
qCn57RxN2sIDxbJSgxrsT0ww4y9RhJFp8dDq/V/THAQPkMN5E+tYwBTzY2hivsfe
g6n349snoXDA9AZs2zClWxG56eep4TZ9XBC4KP66O0NEtLywcqrxKKHroVnE6FBj
4Dof2dOVQnHyDT4E2g6+wDB7sOZdEJedBzE/8EXoLq1TZvjfih1IGw+jxQGw47qi
ogF8j0jF2cnb3a75+1fAkzJ8Bu9Zp+ww8A8D4b9JrNzPQNf8LP3aYebYXy/cH1hz
fFSWjmldWWZ8ahvPWy91WVUnX7AB1RhhfA+H+YtRrSKf8/22WWEnVO1pwQfmXGiS
wMkFyhCbqumak9qFFRdcOHnAB4WBc8GiCkbNq6Q2TfYd45e6jw2Oi/ZoapPrs9ZD
bWAvEJVZIS4n46bowZ2W/yjzQEi+BQevGPorIOaq1bqIzwjlCSVsnRUy569bbSit
JCBTO0LAhNwHKZ9tS3gCS7ECAwEAAaOBmzCBmDAdBgNVHQ4EFgQUi95FEylZ1jfj
Soswfifd+bMdCuMwHwYDVR0jBBgwFoAUi95FEylZ1jfjSoswfifd+bMdCuMwDwYD
VR0TAQH/BAUwAwEB/zBFBgNVHREEPjA8ggdyb2JvY2F0ghFyb2JvY2F0LmhvbWUu
YXJwYYIJKi5yb2JvY2F0ghMqLnJvYm9jYXQuaG9tZS5hcnBhMA0GCSqGSIb3DQEB
CwUAA4ICAQBjTnYtRa5ubQT8cJrTVawdiMUvxpnpgxJVuyWBHzwsNz54J00yIUVD
kPmAF25A8sqlU9J8dQfi0lQ0Rx4AuK0mEKjdS+GQDoqOyvbfKI03vRGfVPHmmBDN
Fl3XX0kKkA8f2Bd7eg2ScLtAmTUrl+3oIqBpJ8ChPZzwUWi5eOcHcKrT4aHdprht
TI09ZBwqHJuOoe0HM3AnhbubQQiXmJjSopuHIzawDQA/moJ92E6zktfQz7VwoFar
rerpcSDGXbgLp98qE6V99sgHry1seg82GyKUcwR+zspI+loev3B+yzpKprsDPcP2
AsbjiMcEOKBb6aItdJCjctiCMz0TkI/jAf20czhWDzF8+1/C6r01CrwsQ+ylldjP
bnkvMDoUsvQ5TBuuVG5zJr8Hi9vPkUhG9OVVfvWa1mVPKjj1bocauMgNGwibr11D
W3rBh9EZLSKYfMw7Gk+DMzBc4nXa1wTww0oEnKR5OhGuMqybiK+TcmMQKyAzhe7v
eQtCk1g9bRz+MPifGoPe6oM1GzPMOwUzJhBYMNSANwnQakhps+paLOYtxEYYDyCd
WzHijiMftmOrTTxurfnuiMAYj4piFm8RgUI8m85eTanH448/qMKIQm1/or/Nh+Ah
5Y6BTmmNamsU60PDaEsqay1VOqe6BZtXE2plvjypzV67ZG3FyUyf6w==
-----END CERTIFICATE-----
''
      ];
    })
    (mkIf cfg.remote {
      environment.systemPackages = with pkgs; with pkgs.nur.repos.dukzcry; [
        moonlight-qt syncthing minicom
      ];
      services.yggdrasil = {
        enable = true;
        persistentKeys = true;
        settings = {
          IfName = "ygg0";
        };
      };
      systemd.services.yggdrasil.wantedBy = mkForce [];
    })
  ];
}
