{
  config,
  pkgs,
  lib,
  ...
}:
let
  qemuPackage = pkgs.qemu-user-static;
  qemuSuffix = "-static";

  # https://github.com/qemu/qemu/blob/master/scripts/qemu-binfmt-conf.sh
  qemu-user-static = {
    qemu-aarch64_be-static = {
      interpreter = "${qemuPackage}/bin/qemu-aarch64_be${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-aarch64-static = {
      enable = !pkgs.stdenv.isAarch64;
      interpreter = "${qemuPackage}/bin/qemu-aarch64${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-alpha-static = {
      interpreter = "${qemuPackage}/bin/qemu-alpha${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x26\x90'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-arm-static = {
      interpreter = "${qemuPackage}/bin/qemu-arm${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-armeb-static = {
      interpreter = "${qemuPackage}/bin/qemu-armeb${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-cris-static = {
      interpreter = "${qemuPackage}/bin/qemu-cris${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x4c\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-hexagon-static = {
      interpreter = "${qemuPackage}/bin/qemu-hexagon${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xa4\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-hppa-static = {
      interpreter = "${qemuPackage}/bin/qemu-hppa${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x0f'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-i386-static = {
      enable = !pkgs.stdenv.isx86_64;
      interpreter = "${qemuPackage}/bin/qemu-i386${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-i686-static = {
      enable = !pkgs.stdenv.isx86_64;
      interpreter = "${qemuPackage}/bin/qemu-i386${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-m68k-static = {
      interpreter = "${qemuPackage}/bin/qemu-m68k${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x04'';
      mask = ''\xff\xff\xff\xff\xff\xff\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-microblaze-static = {
      interpreter = "${qemuPackage}/bin/qemu-microblaze${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xba\xab'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-microblazeel-static = {
      interpreter = "${qemuPackage}/bin/qemu-microblazeel${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xab\xba'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-mips-static = {
      interpreter = "${qemuPackage}/bin/qemu-mips${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-mips64-static = {
      interpreter = "${qemuPackage}/bin/qemu-mips64${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-mips64el-static = {
      interpreter = "${qemuPackage}/bin/qemu-mips64el${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-mipsel-static = {
      interpreter = "${qemuPackage}/bin/qemu-mipsel${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-mipsn32-static = {
      interpreter = "${qemuPackage}/bin/qemu-mipsn32${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-mipsn32el-static = {
      interpreter = "${qemuPackage}/bin/qemu-mipsn32el${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-or1k-static = {
      interpreter = "${qemuPackage}/bin/qemu-or1k${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x5c'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-ppc-static = {
      interpreter = "${qemuPackage}/bin/qemu-ppc${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-ppc64-static = {
      interpreter = "${qemuPackage}/bin/qemu-ppc64${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x15'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-ppc64le-static = {
      interpreter = "${qemuPackage}/bin/qemu-ppc64le${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x15\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\x00'';
    };
    qemu-riscv32-static = {
      interpreter = "${qemuPackage}/bin/qemu-riscv32${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xf3\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-riscv64-static = {
      interpreter = "${qemuPackage}/bin/qemu-riscv64${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xf3\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-s390x-static = {
      interpreter = "${qemuPackage}/bin/qemu-s390x${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x16'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-sh4-static = {
      interpreter = "${qemuPackage}/bin/qemu-sh4${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x2a\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-sh4eb-static = {
      interpreter = "${qemuPackage}/bin/qemu-sh4eb${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x2a'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-sparc-static = {
      interpreter = "${qemuPackage}/bin/qemu-sparc${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x02'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-sparc32plus-static = {
      interpreter = "${qemuPackage}/bin/qemu-sparc32plus${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x12'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-sparc64-static = {
      interpreter = "${qemuPackage}/bin/qemu-sparc64${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x2b'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
    qemu-x86_64-static = {
      enable = !pkgs.stdenv.isx86_64;
      interpreter = "${qemuPackage}/bin/qemu-x86_64${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-xtensa-static = {
      interpreter = "${qemuPackage}/bin/qemu-xtensa${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x5e\x00'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    qemu-xtensaeb-static = {
      interpreter = "${qemuPackage}/bin/qemu-xtensaeb${qemuSuffix}";
      magicOrExtension = ''\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x5e'';
      mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff'';
    };
  };

  # NixOS's binfmt creates a script to call qemu-user-static. Containers don't like that.
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/binfmt.nix
  makeBinfmtLine =
    name:
    {
      enable ? true,
      recognitionType ? "magic",
      offset ? 0,
      magicOrExtension,
      mask,
      preserveArgvZero ? true,
      openBinary ? true,
      interpreter,
      matchCredentials ? true,
      fixBinary ? true,
      ...
    }:
    let
      type = if recognitionType == "magic" then "M" else "E";
      offset' = toString offset;
      mask' = toString mask;
      flags =
        if !(matchCredentials -> openBinary) then
          throw "boot.binfmt.registrations.${name}: you can't specify openBinary = true when matchCredentials = true."
        else
          lib.optionalString preserveArgvZero "P"
          + lib.optionalString (openBinary && !matchCredentials) "O"
          + lib.optionalString matchCredentials "C"
          + lib.optionalString fixBinary "F";
    in
    lib.optionalString enable ":${name}:${type}:${offset'}:${magicOrExtension}:${mask'}:${interpreter}:${flags}";

  enabled = pkgs.stdenv.isx86_64 || pkgs.stdenv.isAarch64;
in
{
  options.lantian.qemu-user-static-binfmt.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable cross-architecture binfmt handling with qemu-user-static.";
  };

  config = lib.mkIf config.lantian.qemu-user-static-binfmt.enable {
    environment.etc."binfmt.d/xddxdd-qemu-user-static.conf".text = lib.optionalString enabled (
      lib.concatStringsSep "\n" (lib.mapAttrsToList makeBinfmtLine qemu-user-static)
    );
    systemd.additionalUpstreamSystemUnits =
      lib.optionals (enabled && config.boot.binfmt.registrations == { })
        [
          "proc-sys-fs-binfmt_misc.automount"
          "proc-sys-fs-binfmt_misc.mount"
          "systemd-binfmt.service"
        ];
    nix.settings.extra-platforms = lib.optionals enabled lib.platforms.linux;
  };
}
