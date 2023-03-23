{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.proftpd;

  inherit (pkgs) proftpd;

  configFile = pkgs.writeText "proftpd.conf"
    ''
      # proftpd.conf
      # generated by proftpd.nix

      User proftpd
      Group proftpd
      # ServerType standalone|inetd
      ServerType standalone
      # DefaultServer on:
      # this server configuration is used as the fallback
      # when a matching vhost cannot be found for an incoming connection
      DefaultServer on
      UseGlobbing off

      # services.proftpd.interfaces
      DefaultAddress ${concatStringsSep " " cfg.interfaces}

      # services.proftpd.port
      Port ${toString cfg.port}

      # services.proftpd.passivePortRangeFrom
      # services.proftpd.passivePortRangeTo
      PassivePorts ${toString cfg.passivePortRangeFrom} ${toString cfg.passivePortRangeTo}

      # services.proftpd.enableIPv6
      UseIPv6 ${if cfg.enableIPv6 then "on" else "off"}

      # services.proftpd.name
      ServerName "${lib.escape [ ''"'' ] cfg.name}"

      # services.proftpd.scoreboardFile
      ScoreboardFile "${lib.escape [ ''"'' ] cfg.scoreboardFile}"

      # services.proftpd.pidFile
      PidFile "${lib.escape [ ''"'' ] cfg.pidFile}"

      # services.proftpd.logFile
      ${if cfg.logFile != null then ''
        SystemLog "${lib.escape [ ''"'' ] cfg.logFile}"
      '' else ""}

      # services.proftpd.logLevel
      SyslogLevel ${cfg.logLevel}

      # services.proftpd.debugLevel
      DebugLevel ${toString cfg.debugLevel}

      # services.proftpd.extraConfig
      ${cfg.extraConfig}
    '';
in

{
  # based on nixpkgs/nixos/modules/services/networking/vsftpd.nix

  ###### interface

  options = {

    services.proftpd = {

      enable = mkEnableOption "proftpd";

      interfaces = mkOption {
        type = types.listOf types.str;
        default = [ "0.0.0.0" ];
        example = [ "127.0.0.1" ];
        description = ''
          The interfaces proftpd will be listening to.  If `[ 127.0.0.1 ]',
          only clients on the local host can connect; if `[ 0.0.0.0 ]', clients
          can access it from any network interface.
        '';
      };

      port = mkOption {
        default = 21;
        description = "TCP port for proftpd";
      };

      # TODO smaller port range?
      passivePortRangeFrom = mkOption {
        default = 49152;
        description = "First port in port range for FTP passive mode";
      };

      passivePortRangeTo = mkOption {
        default = 65535;
        description = "Last port in port range for FTP passive mode";
      };

      openFirewall = mkOption {
        default = true;
        description = "Open firewall ports for proftpd";
      };

      enableIPv6 = mkOption {
        default = false;
      };

      name = mkOption {
        default = "FTP server";
        description = "Human-readable name for the FTP server";
      };

      scoreboardFile = mkOption {
        default = "/var/proftpd/proftpd.scoreboard";
      };

      pidFile = mkOption {
        default = "/var/proftpd/proftpd.pid";
      };

      logFile = mkOption {
        default = null;
        description = "Log to file instead of systemd";
        example = "/var/proftpd/proftpd.log";
      };

      logLevel = mkOption {
        default = "notice";
        description = "Log level. Value: notice info debug"; # TODO
      };

      debugLevel = mkOption {
        default = 0;
        description = "Debug level for logLevel=debug. Values: 0 to 10";
      };

      args = mkOption {
        default = [];
        description = "Arguments for the proftpd command. See: man proftpd";
        example = [ "--nocollision" "--serveraddr" "127.0.0.1" ];
      };

      # TODO?
      #anon.enable = true;
      #anon.root = "/path/to/anon/root";
      #anon.writable = false;

      extraConfig = mkOption {
        default = "";
        description = "Extra content for the proftpd.conf configuration file. See: http://www.proftpd.org/docs/directives/index.html";
        # see also
        # man proftpd
        # man proftpd.conf
        # https://github.com/proftpd/proftpd/tree/master/sample-configurations
        # http://www.proftpd.org/docs/howto/Chroot.html
        # http://www.proftpd.org/docs/howto/Debugging.html

        # check configfile
        # ./pkgs/proftpd/result/bin/proftpd -c /nix/store/bar0wxfdq9nwn4v4psznvks5gwzwj6j2-proftpd.conf -d10 -t

        # run server in foreground
        # ./pkgs/proftpd/result/bin/proftpd -c /nix/store/bar0wxfdq9nwn4v4psznvks5gwzwj6j2-proftpd.conf -d10 -n
        # ./pkgs/proftpd/result/bin/proftpd -c $(readlink -f proftpd.conf) -d10 -n

        # test client
        # curl ftp://127.0.0.1/ -v

        # note: to keep your configuration.nix clean, you can use
        # `services.proftpd.extraConfig = builtins.readFile ./path/to/proftpd.conf;`

        example = ''
          # This is a basic ProFTPD configuration file
          # It establishes a single server and a single anonymous login.

          # http://www.proftpd.org/docs/directives/index.html

          # Umask 022 is a good standard umask to prevent new dirs and files
          # from being group and world writable.
          Umask				022

          # To prevent DoS attacks, set the maximum number of child processes
          # to 30.  If you need to allow more than 30 concurrent connections
          # at once, simply increase this value.  Note that this ONLY works
          # in standalone mode, in inetd mode you should use an inetd server
          # that allows you to limit maximum number of processes per service
          # (such as xinetd).
          MaxInstances			30

          # To cause every FTP user to be "jailed" (chrooted) into their home
          # directory, uncomment this line.
          #DefaultRoot ~

          # Allow to modify existing files?
          #AllowOverwrite		on

          # use PAM to authenticate users
          AuthPAM on

          # read passwords from this file instead of /etc/passwd
          #AuthUserFile /etc/proftpd/passwd

          # enable compression
          #DeflateEngine on

          # on = show link
          # off = resolve link, show file
          ShowSymlinks on

          # should be off for better security
          UseGlobbing off

          # disable the "sendfile" optimization
          # sendfile can cause problems in rare cases
          # http://www.proftpd.org/docs/howto/Sendfile.html
          #UseSendfile off

          # Disable SITE CHMOD by default
          <Limit SITE_CHMOD>
            DenyAll
          </Limit>

          # A basic anonymous configuration, no upload directories.  If you do not
          # want anonymous users, simply delete this entire <Anonymous> section.
          # The <Anonymous> configuration section is used to create an anonymous FTP login,
          # and is closed by a matching </Anonymous> directive.
          # The anon-directory parameter specifies the directory to which the daemon,
          # immediately after successful authentication, will restrict the session via chroot(2).
          #<Anonymous ~ftp>
          <Anonymous /home/user/src/project>
            # the user needs read access to the 
            User				ftp
            Group				ftp
            #User				user
            #Group				users

            # User "anonymous" does not exist in NixOS,
            # but user "ftp" exists -> alias
            UserAlias			anonymous ftp

            # Limit the maximum number of anonymous logins
            MaxClients			10

            # We want 'welcome.msg' displayed at login, and '.message' displayed
            # in each newly chdired directory.
            #DisplayLogin			welcome.msg
            #DisplayChdir			.message

            # Limit WRITE everywhere in the anonymous chroot
            <Limit WRITE>
              DenyAll
            </Limit>
          </Anonymous>
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    # TODO shorter?
    networking.firewall = mkMerge [
      (mkIf cfg.openFirewall {
        allowedTCPPortRanges = [{
          from = cfg.passivePortRangeFrom;
          to = cfg.passivePortRangeTo;
        }];
      })
      (mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.port ];
      })
    ];

    users.users = {
      "proftpd" = {
        group = "proftpd";
        isSystemUser = true;
        description = "proftpd user";
        home = "/homeless-shelter";
        # vsftpd
        #home = if cfg.localRoot != null
        #       then cfg.localRoot # <= Necessary for virtual users.
        #       else "/homeless-shelter";
      };
    }
    #// optionalAttrs cfg.anonymousUser {
    // {
      "ftp" = { name = "ftp";
        uid = config.ids.uids.ftp;
        group = "ftp";
        description = "Anonymous FTP user";
        #home = cfg.anonymousUserHome;
        home = "/var/empty";
      };
    };

    users.groups.proftpd = {};
    users.groups.ftp.gid = config.ids.gids.ftp;

    # based on proftpd/contrib/dist/rpm/proftpd.service
    systemd.services.proftpd = {
      description = "ProFTPD FTP Server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "nss-lookup.target" "local-fs.target" "remote-fs.target" ];
      preStart = ''
        mkdir -p /var/proftpd
        chmod -R +w /var/proftpd
      '';
      serviceConfig = {
        Type = "exec";
        ExecStartPre = [
          "${pkgs.bash}/bin/bash -c 'echo proftpd configfile is ${configFile}'"
          "${proftpd}/bin/proftpd --configtest --config ${configFile}"
        ];
        ExecStart = "${proftpd}/bin/proftpd --nodaemon --config ${configFile} ${lib.escapeShellArgs cfg.args}";
        ExecReload = "${pkgs.procps}/bin/kill -s HUP $MAINPID";
        Environment = "PROFTPD_OPTIONS=";
        PIDFile = "/var/proftpd/proftpd.pid";
        Restart = "on-failure";
      };
    };
  };
}
