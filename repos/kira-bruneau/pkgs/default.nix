{ lib }:

final: prev:

with final;

let
  callPackage = prev.newScope final;

  emacsPackagesOverlay = import ./applications/editors/emacs/elisp-packages/manual-packages {
    inherit lib;
    pkgs = final;
  };

  linuxModulesOverlay =
    if stdenv.isLinux then
      import ./os-specific/linux/modules.nix {
        inherit lib;
        pkgs = final;
      }
    else
      lfinal: lprev: { };

  mapDisabledToBroken =
    attrs:
    (removeAttrs attrs [ "disabled" ])
    // lib.optionalAttrs (attrs.disabled or false) {
      meta = (attrs.meta or { }) // {
        broken = attrs.disabled;
      };
    };

  removeFlakeRoot = path: lib.removePrefix "${toString ../.}/" path;

  fixUpdateScriptArgs =
    drv:
    drv
    // {
      updateScript =
        if builtins.isList drv.updateScript then
          [ (builtins.head drv.updateScript) ]
          ++ (builtins.map removeFlakeRoot (builtins.tail drv.updateScript))
        else
          drv.updateScript;
    };

  pythonModulesOverlay =
    pyfinal:
    import ./development/python-modules
      {
        inherit lib;
        pkgs = final;
      }
      (
        pyfinal
        // {
          buildPythonApplication =
            attrs: fixUpdateScriptArgs (pyfinal.buildPythonApplication (mapDisabledToBroken attrs));
          buildPythonPackage =
            attrs: fixUpdateScriptArgs (pyfinal.buildPythonPackage (mapDisabledToBroken attrs));
        }
      );
in

# Automatically import packages in ./by-name
(lib.foldlAttrs
  (
    acc: _: attrs:
    acc // attrs
  )
  { }
  (
    lib.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./by-name;
    }
  )
)

# Automatically reflect upstream supported python package sets
// (builtins.foldl' (
  acc: name:
  if
    builtins.match "python[0-9]+Packages" name != null && prev.${name}.recurseForDerivations or false
  then
    acc
    // {
      ${name} = recurseIntoAttrs (
        lib.fix (self: pythonModulesOverlay (prev.${name} // self) prev.${name})
      );
    }
  else
    acc
) { } (builtins.attrNames prev))

# Manually defined packages
// {
  inherit callPackage;

  clonehero = callPackage ./games/clonehero { };

  cmake-language-server = python3Packages.callPackage ./development/tools/misc/cmake-language-server {
    inherit cmake cmake-format;
  };

  emacsPackages = recurseIntoAttrs (
    emacsPackagesOverlay (prev.emacsPackages // emacsPackages) prev.emacsPackages
  );

  gamemode = callPackage ./tools/games/gamemode rec {
    libgamemode32 = (pkgsi686Linux.callPackage ./tools/games/gamemode { inherit libgamemode32; }).lib;
  };

  git-review = python3Packages.callPackage ./applications/version-management/git-review { };

  goverlay = callPackage ./tools/graphics/goverlay {
    inherit (qt5) wrapQtAppsHook;
    inherit (plasma5Packages) breeze-qt5;
  };

  krane = callPackage ./applications/networking/cluster/krane { };

  linuxPackages = recurseIntoAttrs (
    linuxModulesOverlay (prev.linuxPackages // linuxPackages) prev.linuxPackages
  );

  mangohud = callPackage ./tools/graphics/mangohud rec {
    libXNVCtrl = prev.linuxPackages.nvidia_x11.settings.libXNVCtrl;
    mangohud32 = pkgsi686Linux.callPackage ./tools/graphics/mangohud {
      libXNVCtrl = pkgsi686Linux.linuxPackages.nvidia_x11.settings.libXNVCtrl;
      inherit mangohud32;
      inherit (pkgsi686Linux.python3Packages) mako;
    };
    inherit (prev.python3Packages) mako;
  };

  mozlz4a = callPackage ./tools/compression/mozlz4a { };

  newsflash = callPackage ./applications/networking/feedreaders/newsflash {
    webkitgtk = webkitgtk_6_0;
  };

  poke = callPackage ./applications/editors/poke { };

  protontricks = python3Packages.callPackage ./tools/package-management/protontricks {
    steam-run = steamPackages.steam-fhsenv-without-steam.run;
    inherit winetricks yad;
  };

  sudachi = qt6Packages.callPackage ./by-name/su/sudachi/package.nix { };

  texlab = callPackage ./development/tools/misc/texlab {
    inherit (darwin.apple_sdk.frameworks) Security CoreServices;
  };

  ukmm = callPackage ./tools/games/ukmm { };

  undistract-me = callPackage ./shells/bash/undistract-me { };

  virtualparadise = callPackage ./by-name/vi/virtualparadise/package.nix {
    inherit (qt5) wrapQtAppsHook;
  };

  vkbasalt = callPackage ./tools/graphics/vkbasalt rec {
    vkbasalt32 = pkgsi686Linux.callPackage ./tools/graphics/vkbasalt { inherit vkbasalt32; };
  };

  yabridge = callPackage ./tools/audio/yabridge { wine = wineWowPackages.staging; };

  yabridgectl = callPackage ./tools/audio/yabridgectl { wine = wineWowPackages.staging; };

  zynaddsubfx = callPackage ./applications/audio/zynaddsubfx {
    guiModule = "zest";
    fftw = fftwSinglePrec;
  };

  zynaddsubfx-fltk = zynaddsubfx.override { guiModule = "fltk"; };

  zynaddsubfx-ntk = zynaddsubfx.override { guiModule = "ntk"; };
}
