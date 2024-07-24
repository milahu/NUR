# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  osirus-clap = {
    pname = "osirus-clap";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-Osirus-CLAP.deb";
      sha256 = "sha256-8F467ILJswNDj3fCU87KptJdwSLuoup3Sn8pqaGsakI=";
    };
  };
  osirus-lv2 = {
    pname = "osirus-lv2";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-Osirus-LV2.deb";
      sha256 = "sha256-6BG1CatGvSVF6SEuMSLumI/8L35Iw1xaoaQssIC1uQY=";
    };
  };
  osirus-test-console = {
    pname = "osirus-test-console";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-OsirusTestConsole.deb";
      sha256 = "sha256-VrFTPIKLS5bGkk4gmLKg7NTbrF7r5q5K74DUy1mP7Fo=";
    };
  };
  osirus-vst2 = {
    pname = "osirus-vst2";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-Osirus-VST2.deb";
      sha256 = "sha256-V113I5sXvfkniW1mwWb8hL28VLB4A8Xj2no8bEZAYR4=";
    };
  };
  osirus-vst3 = {
    pname = "osirus-vst3";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-Osirus-VST3.deb";
      sha256 = "sha256-edD959pI8mKr4Stagw9XWKwZWSNZlZQEfKa9kPVBEio=";
    };
  };
  osirusfx-clap = {
    pname = "osirusfx-clap";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-OsirusFX-CLAP.deb";
      sha256 = "sha256-4kxwAhSEiFCwQ/4f2P8GnY+DUF89IKI7yYGcGP/qRIg=";
    };
  };
  osirusfx-lv2 = {
    pname = "osirusfx-lv2";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-OsirusFX-LV2.deb";
      sha256 = "sha256-FXl8yWUT3XB5dkQPlEjeigrbvBk/NPgFghrwhePnLVQ=";
    };
  };
  osirusfx-vst2 = {
    pname = "osirusfx-vst2";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-OsirusFX-VST2.deb";
      sha256 = "sha256-YxCOYfSOziFytBBi72xDlCWzR0OL/9kQKbeL1UeIX4o=";
    };
  };
  osirusfx-vst3 = {
    pname = "osirusfx-vst3";
    version = "1.3.14";
    src = fetchurl {
      url = "https://futurenoize.com/dsp56300/builds/osirus/DSP56300Emu-1.3.14-Linux_x86_64-OsirusFX-VST3.deb";
      sha256 = "sha256-ypKI7X60jvC2cz6F2Mpr3mLlo9JpDEx77fMNc4Xf2oA=";
    };
  };
}