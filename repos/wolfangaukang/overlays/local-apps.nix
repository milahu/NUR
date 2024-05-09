final: prev:
{
  # FIXME: Find the reason this overlay is not building the newest version
  #upwork = prev.upwork.overrideAttrs ( old: rec {
  #  version = "5.6.10.23";

  #  src = prev.requireFile rec {
  #    name = "upwork_${version}_amd64.deb";
  #    url = "https://www.upwork.com/ab/downloads/os/linux/";
  #    sha256 = "bda27388df444e291842cc306b719d7e91836ad172b196689d108d8f287dc89e";
  #  };

  #  dontBuild = false;
  #  dontConfigure = false;
  #} );
  #upwork-require = prev.callPackage ../pkgs/applications/misc/upwork {};
  burpsuite = prev.callPackage ../pkgs/burpsuite/ce.nix { };
  vdhcoapp = prev.callPackage ../pkgs/vdhcoapp { };
  rofiwl-custom = prev.rofi-wayland.override {
    plugins = with prev.pkgs; [
      (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
      (rofi-top.override { rofi-unwrapped = rofi-wayland-unwrapped; })
    ];
  };
}
