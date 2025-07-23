{ config, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = false;
  services.xserver.videoDrivers = [ "nvidia" ];
  vacu.packages = "nv-codec-headers-12";
}
