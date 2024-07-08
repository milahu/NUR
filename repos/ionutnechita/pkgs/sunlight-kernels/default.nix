{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  modDirVersion = "6.9.8-lowlatency-sunlight1";

  parts = lib.splitString "-" modDirVersion;

  version = lib.elemAt parts 0;
  flavour = lib.elemAt parts 1;
  suffix = lib.elemAt parts 2;

  numbers = lib.splitString "." version;
  branch = "${lib.elemAt numbers 0}.${lib.elemAt numbers 1}";

  rev = "${version}-${flavour}-${suffix}";

  hash = "sha256-vwLfmoim7OGoKDIeuGVaP2TwIkoss0NKBrWIfBsnWYM=";
in
buildLinux (args // rec {
    inherit version modDirVersion;

    src = fetchFromGitHub {
      owner = "sunlightlinux";
      repo = "linux-sunlight";
      inherit rev hash;
    };

    extraMakeFlags = [
	"KBUILD_BUILD_VERSION_TIMESTAMP=SUNLIGHT"
    ];

    structuredExtraConfig = with lib.kernel; {
      # Expert option for built-in default values.
      GKI_HACKS_TO_FIX = yes;

      # AMD P-state driver.
      X86_AMD_PSTATE = lib.mkOverride 60 yes;
      X86_AMD_PSTATE_UT = no;

      # Google's BBRv3 TCP congestion Control.
      TCP_CONG_BBR = yes;
      DEFAULT_BBR = yes;

      # FQ-PIE Packet Scheduling.
      NET_SCH_DEFAULT = yes;
      DEFAULT_FQ_PIE = yes;

      # Futex WAIT_MULTIPLE implementation for Wine / Proton Fsync.
      FUTEX = yes;
      FUTEX_PI = yes;

      # Preemptive Full Tickless Kernel at 858Hz.
      LATENCYTOP = yes;

      PREEMPT = lib.mkOverride 60 yes;
      PREEMPT_VOLUNTARY = lib.mkForce no;
      PREEMPT_NONE = lib.mkForce no;

      # NTSYNC driver for fast kernel-backed Wine.
      NTSYNC = yes;

      # Full Cone NAT driver.
      NFT_FULLCONE = module;

      # OpenRGB driver.
      I2C_NCT6775 = module;

      # 858 Hz is alternative to 1000 Hz.
      # Selected value for a balance between latency, performance and low power consumption.
      HZ = freeform "858";
      HZ_858 = yes;
      HZ_1000 = no;

      SCHEDSTATS = lib.mkOverride 60 yes;
      HID = yes;
      UHID = yes;
    };

    ignoreConfigErrors = true;

    extraMeta = {
      inherit branch;
      maintainers = with lib.maintainers; [ ionutnechita ];
      description = "Sunlight Kernel. Built with custom settings and new features
                     built to provide a stable, responsive and smooth desktop experience";
    };
} // (args.argsOverride or { }))
