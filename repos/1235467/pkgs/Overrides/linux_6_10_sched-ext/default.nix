{ stdenv
, pkgs
, lib
, ...
}:
pkgs.linux_6_10.override {
extraConfig = ''
          CONFIG_SCHED_CLASS_EXT y
          CONFIG_BPF_SYSCALL y
          CONFIG_BPF_JIT y 
	  CONFIG_DEBUG_INFO_BTF y
          CONFIG_BPF_JIT_ALWAYS_ON y
          CONFIG_PAHOLE_HAS_BTF_TAG y 
        '';
}
