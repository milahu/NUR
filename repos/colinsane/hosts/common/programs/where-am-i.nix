{ config, pkgs, ... }:
{
  sane.programs.where-am-i = {
    # packageUnwrapped = pkgs.linkIntoOwnPackage config.sane.programs.geoclue2.packageUnwrapped "libexec/geoclue-2.0/demos/where-am-i";
    packageUnwrapped = pkgs.linkFarm "where-am-i" [{
      # bring the `where-am-i` tool into a `bin/` directory so it can be invokable via PATH
      name = "bin/where-am-i";
      path = "${config.sane.programs.geoclue2.packageUnwrapped}/libexec/geoclue-2.0/demos/where-am-i";
    }];

    sandbox.method = "bwrap";
    sandbox.net = "all";  # TODO: why does it require this? i think it just needs *some* net dev and any will do.
    sandbox.whitelistDbus = [
      "system"  # system is required for non-portal location services
    ];
    sandbox.usePortal = false;  # TODO: set up portal-based location services
  };
}