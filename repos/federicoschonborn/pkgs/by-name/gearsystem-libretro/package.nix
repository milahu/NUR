{
  lib,
  stdenv,
  gearsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "${lib.getName gearsystem}-libretro";
  inherit (gearsystem) version;

  inherit (gearsystem) src;

  makeFlags = [
    "-C"
    "platforms/libretro"
    "prefix=$(out)"
    "GIT_VERSION=${finalAttrs.src.tag}"
    "LIBRETRO_INSTALL_DIR=retroarch/cores"
  ];

  meta = {
    inherit (gearsystem.meta)
      description
      homepage
      license
      platforms
      maintainers
      ;
  };
})
