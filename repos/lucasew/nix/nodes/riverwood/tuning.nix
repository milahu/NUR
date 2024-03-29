{pkgs, ...}: {
  nix.settings = {
      min-free = 1  * 1024*1024*1024;
      max-free = 10 * 1024*1024*1024;
  };

  services.auto-cpufreq.enable = true;
  services.tlp.enable = true;

  hardware = {
    bluetooth.enable = true;
    opengl = {
      extraPackages = with pkgs; [
        # intel-compute-runtime
        # beignet
        intel-ocl
        vaapiIntel
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiIntel
      ];
    };
  };

  # não deixar explodir
  nix.settings.max-jobs = 3;
}
