{ lib
, linux_6_1
, linuxManualConfig
, writeTextFile
#v nixpkgs calls `.override` on the kernel to configure additional things
, features ? []
, randstructSeed ? ""
, ...
}@args:

let
  # TODO: lift to shared module
  parseKconfigLine = line: let
    pieces = lib.splitString "=" line;
  in
    if lib.hasPrefix "#" (lib.head pieces) then [
      # this line is a comment.
      # N.B.: this could be like `# CONFIG_FOO is not set`, which i might want to report as `n`
    ] else if lib.length pieces == 1 then [
      # no equals sign: this is probably a blank line
    ] else [{
      name = lib.head pieces;
      # value = parseKconfigValue (lib.concatStringsSep "=" (lib.tail pieces));
      # nixpkgs kernel config is some real fucking bullshit: it wants a plain string here instead of the structured config it demands eeeeeeverywhere else.
      value = lib.concatStringsSep "=" (lib.tail pieces);
    }]
  ;
  parseKconfig = wholeStr: let
    lines = lib.splitString "\n" wholeStr;
    parsedItems = lib.concatMap parseKconfigLine lines;
  in
    lib.listToAttrs parsedItems;

  # remove CONFIG_LOCALVERSION else nixpkgs complains about mismatched modDirVersion
  KconfigStr = lib.replaceStrings
    [
      ''CONFIG_LOCALVERSION="-postmarketos-exynos5"''
      ''CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y''
      ''CONFIG_BATTERY_SBS=y''
    ]
    [
      ''CONFIG_LOCALVERSION=''
      # XXX(2024/06/06): if the bzImage is too large, it fails to boot.
      # probably an issue with the uboot relocations; not sure exactly what the size limit is.
      ''CONFIG_CC_OPTIMIZE_FOR_SIZE=y''
      # XXX(2024/06/06): if this module is loaded before udev, then kernel panic.
      # see: <repo:NixOS/mobile-nixos:devices/families/mainline-chromeos/default.nix>
      ''CONFIG_BATTERY_SBS=m''
    ]
    (builtins.readFile ./config-postmarketos-exynos5.arm7)
  + ''
    #
    # Extra nixpkgs-specific options
    # nixos/modules/system/boot/systemd.nix wants CONFIG_DMIID
    #
    CONFIG_DMIID=y

    #
    # Extra sane-specific options
    #
    CONFIG_SECURITY_LANDLOCK=y
    CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf";

  '';
in linuxManualConfig {
  inherit (linux_6_1) extraMakeFlags modDirVersion src version;
  inherit features randstructSeed;
  kernelPatches = args.kernelPatches or [];

  configfile = writeTextFile {
    name = "config-postmarketos-exynos5.arm7";
    text = KconfigStr;
  };
  # nixpkgs requires to know the config as an attrset, to do various eval-time assertions.
  # this forces me to include the Kconfig inline, instead of fetching it the way i do all the other pmOS kernel stuff.
  config = parseKconfig KconfigStr;
}
