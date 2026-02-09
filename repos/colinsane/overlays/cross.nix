# tracking:
# - all cross compilation PRs: <https://github.com/NixOS/nixpkgs/labels/6.topic%3A%20cross-compilation>
# - potential idiom to fix cross cargo-inside-meson: <https://github.com/NixOS/nixpkgs/pull/434878>

final: prev:
let
  inherit (prev) lib;
  ## package override helpers
  addInputs = { buildInputs ? [], nativeBuildInputs ? [], depsBuildBuild ? [] }: pkg: pkg.overrideAttrs (upstream: {
    buildInputs = upstream.buildInputs or [] ++ buildInputs;
    nativeBuildInputs = upstream.nativeBuildInputs or [] ++ nativeBuildInputs;
    depsBuildBuild = upstream.depsBuildBuild or [] ++ depsBuildBuild;
  });
  addNativeInputs = nativeBuildInputs: addInputs { inherit nativeBuildInputs; };
  addBuildInputs = buildInputs: addInputs { inherit buildInputs; };
  addDepsBuildBuild = depsBuildBuild: addInputs { inherit depsBuildBuild; };
  mvToNativeInputs = nativeBuildInputs: mvInputs { inherit nativeBuildInputs; };
  mvToBuildInputs = buildInputs: mvInputs { inherit buildInputs; };
  mvToDepsBuildBuild = depsBuildBuild: mvInputs { inherit depsBuildBuild; };
  rmInputs = { buildInputs ? [], depsBuildBuild ? [], nativeBuildInputs ? [] }: pkg: pkg.overrideAttrs (upstream: {
    buildInputs = lib.filter
      (p: !lib.any (rm: p == rm || (p ? name && rm ? name && p.name == rm.name)) buildInputs)
      (upstream.buildInputs or [])
    ;
    depsBuildBuild = lib.filter
      (p: !lib.any (rm: p == rm || (p ? name && rm ? name && p.name == rm.name)) depsBuildBuild)
      (upstream.depsBuildBuild or [])
    ;
    nativeBuildInputs = lib.filter
      (p: !lib.any (rm: p == rm || (p ? name && rm ? name && p.name == rm.name)) nativeBuildInputs)
      (upstream.nativeBuildInputs or [])
    ;
  });
  rmBuildInputs = buildInputs: rmInputs { inherit buildInputs; };
  rmNativeInputs = nativeBuildInputs: rmInputs { inherit nativeBuildInputs; };
  # move items from buildInputs into nativeBuildInputs, or vice-versa.
  # arguments represent the final location of specific inputs.
  mvInputs = { buildInputs ? [], depsBuildBuild ? [], nativeBuildInputs ? [] }: pkg:
    addInputs { inherit buildInputs depsBuildBuild nativeBuildInputs; }
    (
      rmInputs
        {
          buildInputs = depsBuildBuild ++ nativeBuildInputs;
          depsBuildBuild = buildInputs ++ nativeBuildInputs;
          nativeBuildInputs = buildInputs ++ depsBuildBuild;
        }
        pkg
    );

  # build a GI_TYPELIB_PATH out of some packages, useful for build-time tools which otherwise
  # try to load gobject-introspection files for the wrong platform (e.g. `gjspack`).
  typelibPath = pkgs: lib.concatStringsSep ":" (builtins.map (p: "${lib.getLib p}/lib/girepository-1.0") pkgs);

  # `cargo` which adds the correct env vars and `--target` flag when invoked from meson build scripts.
  # use like `foo = prev.foo.override { cargo = crossCargo; }`.
  # the nixpkgs-upstreaming compatible patch looks more like this:
  # - <https://github.com/NixOS/nixpkgs/pull/437748/files>
  # 1. `env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;`
  # 2. `postPatch += ...` to patch `rust_target` to `'${stdenv.hostPlatform.rust.cargoShortTarget}'` in meson.build
  crossCargo = let
    inherit (final.pkgsBuildHost) cargo;
    inherit (final.rust.envVars) setEnv rustHostPlatformSpec;
  in (final.pkgsBuildBuild.writeShellScriptBin "cargo" ''
    targetDir=target
    isFlavored=
    outDir=
    profile=

    cargoArgs=("$@")
    nextIsOutDir=
    nextIsProfile=
    nextIsTargetDir=
    for arg in "''${cargoArgs[@]}"; do
      if [[ -n "$nextIsOutDir" ]]; then
        nextIsOutDir=
        outDir="$arg"
      elif [[ -n "$nextIsProfile" ]]; then
        nextIsProfile=
        profile="$arg"
      elif [[ -n "$nextIsTargetDir" ]]; then
        nextIsTargetDir=
        targetDir="$arg"
      elif [[ "$arg" = "build" ]]; then
        isFlavored=1
      elif [[ "$arg" = "--out-dir" ]]; then
        nextIsOutDir=1
      elif [[ "$arg" = "--profile" ]]; then
        nextIsProfile=1
      elif [[ "$arg" = "--release" ]]; then
        profile=release
      elif [[ "$arg" = "--target-dir" ]]; then
        nextIsTargetDir=1
      fi
    done

    extraFlags=()

    # not all subcommands support flavored arguments like `--target`
    if [ -n "$isFlavored" ]; then
      # pass the target triple to cargo so it will cross compile
      # and fix so it places outputs in the same directory as non-cross, see: <https://doc.rust-lang.org/cargo/guide/build-cache.html>
      extraFlags+=(
        --target "${rustHostPlatformSpec}"
        -Z unstable-options
      )
      if [ -z "$outDir" ]; then
        extraFlags+=(
          --out-dir "$targetDir"/''${profile:-debug}
        )
      fi
    fi

    exec ${setEnv} "${lib.getExe cargo}" "$@" "''${extraFlags[@]}"
  '').overrideAttrs {
    inherit (cargo) meta;
  };
in with final; {
  # 2025/12/07: appears to be no longer required
  # armTrustedFirmwareRK3399 = prev.armTrustedFirmwareRK3399.overrideAttrs (upstream: {
  #   # 2025-10-06: fixes "arm-none-eabi-ld: /build/source/build/rk3399/release/m0/rk3399m0pmu.elf: error: PHDR segment not covered by LOAD segment".
  #   # TODO: send this to upstream arm-trusted-firmware, then PR a cherry-pick into nixpkgs
  #   patches = (upstream.patches or []) ++ [
  #     (pkgs.fetchpatch2 {
  #       name = "fix(rockchip): set no-pie option when building m0 elf file";
  #       url = "https://git.uninsane.org/colin/arm-trusted-firmare/commit/c192c366b8c423a6bf4293573fccfc258e801c87.patch";
  #       hash = "sha256-oXAJe3pahe3dnYfpmmW8KbSpN8XIzc1Zpm1CvXNrnAY=";
  #     })
  #   ];
  # });

  # binutils = prev.binutils.override {
  #   # fix that resulting binary files would specify build #!sh as their interpreter.
  #   # dtrx is the primary beneficiary of this.
  #   # this doesn't actually cause mass rebuilding.
  #   # note that this isn't enough to remove all build references:
  #   # - expand-response-params still references build stuff.
  #   shell = runtimeShell;
  # };


  # 2026/01/27: upstreaming is unblocked, but a cleaner solution than this doesn't seem to exist yet
  confy = prev.confy.overrideAttrs (upstream: {
    # meson's `python.find_installation` method somehow just doesn't support cross compilation.
    # - <https://mesonbuild.com/Python-module.html#find_installation>
    # so, build it to target build python, then patch in the host python
    nativeBuildInputs = upstream.nativeBuildInputs ++ [
      python3.pythonOnBuildForHost
    ];
    postFixup = ''
      substituteInPlace $out/bin/.confy-wrapped --replace-fail ${python3.pythonOnBuildForHost} ${python3.withPackages (
        ps: with ps; [
          icalendar
          pygobject3
        ]
      )}
    '';
  });

  # 2025/07/27: upstreaming is unblocked
  # dtrx = prev.dtrx.override {
  #   # `binutils` is the nix wrapper, which reads nix-related env vars
  #   # before passing on to e.g. `ld`.
  #   # dtrx probably only needs `ar` at runtime, not even `ld`.
  #   # this isn't required to fix the _build_, nor even runtime behavior (probably); it's a cleanliness fix (fewer build packages in runtime closure)
  #   binutils = binutils-unwrapped;
  # };

  # envelope = prev.envelope.override {
  #   cargo = crossCargo;
  # };

  # 2025/12/07: upstreaming is blocked on mailutils -> gss -> shishi
  # emacs = prev.emacs.override {
  #   nativeComp = false;  # will be renamed to `withNativeCompilation` in future
  #   # future: we can specify 'action-if-cross-compiling' to actually invoke the test programs:
  #   # <https://www.gnu.org/software/autoconf/manual/autoconf-2.63/html_node/Runtime.html>
  # };

  # 2025/12/07: upstreaming is unblocked
  # firejail = prev.firejail.overrideAttrs (upstream: {
  #   # firejail executes its build outputs to produce the default filter list.
  #   # i think we *could* copy the default filters from pkgsBuildBuild, but that doesn't seem future proof
  #   # for any (future) arch-specific filtering
  #   postPatch = (upstream.postPatch or "") + (let
  #     emulator = stdenv.hostPlatform.emulator buildPackages;
  #   in lib.optionalString (!prev.stdenv.buildPlatform.canExecute prev.stdenv.hostPlatform) ''
  #     substituteInPlace Makefile \
  #       --replace-fail '	src/fseccomp/fseccomp' '	${emulator} src/fseccomp/fseccomp' \
  #       --replace-fail '	src/fsec-optimize/fsec-optimize' '	${emulator} src/fsec-optimize/fsec-optimize'
  #   '');
  # });

  # 2025/12/07: upstreaming is unblocked
  # flare-signal = prev.flare-signal.overrideAttrs (upstream: {
  #    env = let
  #      inherit buildPackages stdenv rust;
  #      ccForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  #      cxxForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++";
  #      ccForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  #      cxxForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++";
  #      rustBuildPlatform = stdenv.buildPlatform.rust.rustcTarget;
  #      rustTargetPlatform = stdenv.hostPlatform.rust.rustcTarget;
  #      rustTargetPlatformSpec = stdenv.hostPlatform.rust.rustcTargetSpec;
  #    in {
  #      # taken from <pkgs/build-support/rust/hooks/default.nix>
  #      # fixes "cargo:warning=aarch64-unknown-linux-gnu-gcc: error: unrecognized command-line option ‘-m64’"
  #      # XXX: these aren't necessarily valid environment variables: the referenced nix file is more clever to get them to work.
  #      "CC_${rustBuildPlatform}" = "${ccForBuild}";
  #      "CXX_${rustBuildPlatform}" = "${cxxForBuild}";
  #      "CC_${rustTargetPlatform}" = "${ccForHost}";
  #      "CXX_${rustTargetPlatform}" = "${cxxForHost}";
  #    };
  # });

  # 2025/07/27: upstreaming is blocked on gnome-shell
  # fixes: "gdbus-codegen not found or executable"
  # gnome-session = mvToNativeInputs [ glib ] super.gnome-session;

  # 2025/08/31: upstreaming is blocked on evolution-data-server -> gnome-online-accounts -> gvfs -> ... -> ruby
  # gnome-shell = super.gnome-shell.overrideAttrs (orig: {
  #   # fixes "meson.build:128:0: ERROR: Program 'gjs' not found or not executable"
  #   # does not fix "_giscanner.cpython-310-x86_64-linux-gnu.so: cannot open shared object file: No such file or directory"  (python import failure)
  #   nativeBuildInputs = orig.nativeBuildInputs ++ [ gjs gobject-introspection ];
  #   # try to reduce gobject-introspection/shew dependencies
  #   mesonFlags = [
  #     "-Dextensions_app=false"
  #     "-Dextensions_tool=false"
  #     "-Dman=false"
  #   ];
  #   # fixes "gvc| Build-time dependency gobject-introspection-1.0 found: NO"
  #   # inspired by gupnp_1_6
  #   # outputs = [ "out" "dev" ]
  #   #   ++ lib.optionals (prev.stdenv.buildPlatform == prev.stdenv.hostPlatform) [ "devdoc" ];
  #   # mesonFlags = [
  #   #   "-Dgtk_doc=${lib.boolToString (prev.stdenv.buildPlatform == prev.stdenv.hostPlatform)}"
  #   # ];
  # });
  # gnome-shell = super.gnome-shell.overrideAttrs (upstream: {
  #   nativeBuildInputs = upstream.nativeBuildInputs ++ [
  #     gjs  # fixes "meson.build:128:0: ERROR: Program 'gjs' not found or not executable"
  #   ];
  # });

  # 2025/12/07: upstreaming is unblocked
  # # gnustep is going to need a *lot* of work/domain-specific knowledge to truly cross-compile,
  # gnustep-base = prev.gnustep-base.overrideAttrs (upstream: {
  #   # fixes: "checking FFI library usage... ./configure: line 11028: pkg-config: command not found"
  #   # nixpkgs has this in nativeBuildInputs... but that's failing when we partially emulate things.
  #   buildInputs = (upstream.buildInputs or []) ++ [ prev.pkg-config ];
  # });

  # 2026/01/27: hyprland is blocked on hyprland-qtutils -> hyprland-qt-support
  # hyprland = prev.hyprland.override {
  #   # 2025/07/18: NOT FOR UPSTREAM.
  #   # hyprland uses gcc15Stdenv, with mold patch -> doesn't apply when cross compiling.
  #   # the package fails even after fixing stdenv, though.
  #   # stdenv = gcc14Stdenv;
  #   # stdenv = prev.stdenv;
  # };
  # only `nwg-panel` uses hyprland; `null`ing it seems to Just Work.
  hyprland = null;

  # 2026/01/27: blocked on hyprland-qt-support
  # used by hyprland (which is an indirect dep of waybar, nwg-panel, etc),
  # which it shells out to at runtime (and hence, not ever used by me).
  hyprland-qtutils = null;

  # 2025/12/07: upstreaming is blocked on java-service-wrapper
  # "setup: line 1595: ant: command not found"
  # i2p = mvToNativeInputs [ ant gettext ] prev.i2p;

  # 2024/08/12: upstreaming is blocked on lua, lpeg, pandoc, unicode-collation, etc
  # iotas = prev.iotas.overrideAttrs (_: {
  #   # error: "<iotas> is not allowed to refer to the following paths: <build python>"
  #   # disallowedReferences = [];
  #   postPatch = ''
  #     # @PYTHON@ becomes the build python, but this file isn't executable anyway so shouldn't have a shebang
  #     substituteInPlace iotas/const.py.in \
  #       --replace-fail '#!@PYTHON@' ""
  #   '';
  # });

  # jellyfin-media-player = mvToBuildInputs
  #   [ libsForQt5.wrapQtAppsHook ]  # this shouldn't be: but otherwise we get mixed qtbase deps
  #   (prev.jellyfin-media-player.overrideAttrs (upstream: {
  #     meta = upstream.meta // {
  #       platforms = upstream.meta.platforms ++ [
  #         "aarch64-linux"
  #       ];
  #     };
  #   }));
  # jellyfin-media-player-qt6 = prev.jellyfin-media-player-qt6.overrideAttrs (upstream: {
  #   # nativeBuildInputs => result targets x86.
  #   # buildInputs => result targets correct platform, but doesn't wrap the runtime deps
  #   # TODO: fix the hook in qt6 itself?
  #   depsHostHost = upstream.depsHostHost or [] ++ [ qt6.wrapQtAppsHook ];
  #   nativeBuildInputs = lib.remove [ qt6.wrapQtAppsHook ] upstream.nativeBuildInputs;
  # });

  # lemoa = prev.lemoa.override { cargo = crossCargo; };

  # 2026/01/27: upstreaming is unblocked
  libglycin = prev.libglycin.override {
    cargo = crossCargo;
    # XXX(2026-02-04): users like `loupe`, `fractal`, place `libglycin.patchVendorHook` into `nativeBuildInputs`.
    # that doesn't splice, and it's generally unclear what the correct solution is to this.
    # further, the hook itself mixes build and host dependencies:
    # `jq` and `sponge` (moreutils) are used at hook time, whereas `bwrap` is injected by the hook into the package to be built.
    jq = final.buildPackages.jq;
    moreutils = final.buildPackages.moreutils;
    # leave bwrap unmodified -- it ought to be a runtime dependency
  };

  # libsForQt5 = prev.libsForQt5.overrideScope (self: super: {
  #   # 2025/07/27: upstreaming is blocked on qtsvg
  #   phonon = super.phonon.overrideAttrs (orig: {
  #     # fixes "ECM (required version >= 5.60), Extra CMake Modules"
  #     buildInputs = orig.buildInputs ++ [ extra-cmake-modules ];
  #   });
  # });
  # libsForQt5 = prev.libsForQt5.overrideScope (self: super: {
  #   # emulate all the qt5 packages, but rework `libsForQt5.callPackage` and `mkDerivation`
  #   # to use non-emulated stdenv by default.
  #   mkDerivation = self.mkDerivationWith stdenv.mkDerivation;
  #   callPackage = self.newScope { inherit (self) qtCompatVersion qtModule srcs; inherit stdenv; };
  # });

  # 2026/01/27: upstreaming is unblocked
  mepo = (prev.mepo.override {
    # nixpkgs mepo correctly puts `zig_0_14.hook` in nativeBuildInputs,
    # but that ends up being the wrong offset: `hook` isn't spliced.
    # see:
    # - pkgs/development/compilers/zig/generic.nix
    # - pkgs/development/compilers/zig/passthru.nix
    # even if `zig_0_14` has a `__spliced` attribute, its _passthru_ isn't spliced:
    # `zig_0_14.passthru.hook` (and others) are designed to run on the _host_.
    # the easiest correct fix is likely `makeScopeWithSplicing`.
    zig_0_14 = buildPackages.zig_0_14;
  }).overrideAttrs (upstream: {
    nativeBuildInputs = upstream.nativeBuildInputs ++ [
      # zig hardcodes the /lib/ld-linux.so interpreter which breaks nix dynamic linking & dep tracking.
      # this shouldn't have to be buildPackages.autoPatchelfHook...
      # but without specifying `buildPackages` the host coreutils ends up on the builder's path and breaks things
      buildPackages.autoPatchelfHook
    ];
    postPatch = (upstream.postPatch or "") + ''
      substituteInPlace src/sdlshim.zig \
        --replace-fail 'cInclude("SDL2/SDL2_gfxPrimitives.h")' 'cInclude("SDL2_gfxPrimitives.h")' \
        --replace-fail 'cInclude("SDL2/SDL_image.h")' 'cInclude("SDL_image.h")' \
        --replace-fail 'cInclude("SDL2/SDL_ttf.h")' 'cInclude("SDL_ttf.h")'
    '';
    # fix the self-documenting build of share/doc/mepo/documentation.md
    postInstall = lib.replaceStrings
      [ "$out/bin/mepo " ]
      [ "${stdenv.hostPlatform.emulator buildPackages} $out/bin/mepo " ]
      ''
        autoPatchelf "$out"
        ${upstream.postInstall}
      '';
    # optional `zig build` debugging flags:
    # - --verbose
    # - --verbose-cimport
    # - --help
    zigBuildFlags = [ "-Dtarget=aarch64-linux-gnu" ];
  });

  # fixes: "ar: command not found"
  # `ar` is provided by bintools
  # 2025/12/07: upstreaming is unblocked by deps; but turns out to not be this simple
  # ncftp = addNativeInputs [ bintools ] prev.ncftp;

  # fixes "properties/gresource.xml: Permission denied"
  #   - by providing glib-compile-resources
  # 2025/07/27: upstreaming is blocked on gst-plugins-good, qtkeychain, qtmultimedia, qtquick3d, qt-jdenticon
  # nheko = (prev.nheko.override {
  #   gst_all_1 = gst_all_1 // {
  #     # don't build gst-plugins-good with "qt5 support"
  #     # alternative build fix is to remove `qtbase` from nativeBuildInputs:
  #     # - that avoids the mixd qt5 deps, but forces a rebuild of gst-plugins-good and +20MB to closure
  #     gst-plugins-good.override = attrs: gst_all_1.gst-plugins-good.override (builtins.removeAttrs attrs [ "qt5Support" ]);
  #   };
  # }).overrideAttrs (orig: {
  #   # fixes "fatal error: lmdb++.h: No such file or directory
  #   buildInputs = orig.buildInputs ++ [ lmdbxx ];
  # });
  # 2025/07/27: upstreaming blocked on emacs, ruby (via vim-gems)
  # - previous upstreaming attempt: <https://github.com/NixOS/nixpkgs/pull/225111/files>
  # notmuch = prev.notmuch.overrideAttrs (upstream: {
  #   # fixes "Error: The dependencies of notmuch could not be satisfied"  (xapian, gmime, glib, talloc)
  #   # when cross-compiling, we only have a triple-prefixed pkg-config which notmuch's configure script doesn't know how to find.
  #   # so just replace these with the nix-supplied env-var which resolves to the relevant pkg-config.
  #   postPatch = upstream.postPatch or "" + ''
  #     sed -i 's/pkg-config/\$PKG_CONFIG/g' configure
  #   '';
  #   XAPIAN_CONFIG = buildPackages.writeShellScript "xapian-config" ''
  #     exec ${lib.getBin xapian}/bin/xapian-config $@
  #   '';
  #   # depsBuildBuild = [ gnupg ];
  #   nativeBuildInputs = upstream.nativeBuildInputs ++ [
  #     gnupg  # nixpkgs specifies gpg as a buildInput instead of a nativeBuildInput
  #     perl  # used to build manpages
  #     # pythonPackages.python
  #     # shared-mime-info
  #   ];
  #   buildInputs = [
  #     xapian gmime3 talloc zlib  # dependencies described in INSTALL
  #     # perl
  #     # pythonPackages.python
  #     ruby  # notmuch links against ruby.so
  #   ];
  #   # buildInputs =
  #   #   (lib.remove
  #   #     perl
  #   #     (lib.remove
  #   #       gmime
  #   #       (lib.remove gnupg upstream.buildInputs)
  #   #     )
  #   #   ) ++ [ gmime ];
  # });
  # notmuch = prev.notmuch.overrideAttrs (upstream: {
  #   # fixes "Error: The dependencies of notmuch could not be satisfied"  (xapian, gmime, glib, talloc)
  #   # when cross-compiling, we only have a triple-prefixed pkg-config which notmuch's configure script doesn't know how to find.
  #   # so just replace these with the nix-supplied env-var which resolves to the relevant pkg-config.
  #   postPatch = upstream.postPatch or "" + ''
  #     sed -i 's/pkg-config/\$PKG_CONFIG/g' configure
  #     sed -i 's: gpg : ${buildPackages.gnupg}/bin/gpg :' configure
  #   '';
  #   XAPIAN_CONFIG = buildPackages.writeShellScript "xapian-config" ''
  #     exec ${lib.getBin xapian}/bin/xapian-config $@
  #   '';
  #   # depsBuildBuild = upstream.depsBuildBuild or [] ++ [
  #   #   buildPackages.stdenv.cc
  #   # ];
  #   nativeBuildInputs = upstream.nativeBuildInputs ++ [
  #     # gnupg
  #     perl
  #   ];
  #   # buildInputs = lib.remove gnupg upstream.buildInputs;
  # });

  # 2026/01/27: upstreaming is unblocked, but most of this belongs in _oils_ repo
  oils-for-unix = prev.oils-for-unix.overrideAttrs (upstream: {
    postPatch = (upstream.postPatch or "") + ''
      substituteInPlace _build/oils.sh \
        --replace-fail ' strip ' ' ${stdenv.cc.targetPrefix}strip '
    '';

    buildPhase = lib.replaceStrings
      [ "_build/oils.sh" ]
      [ "_build/oils.sh --cxx ${stdenv.cc.targetPrefix}c++" ]
      upstream.buildPhase
    ;

    installPhase = lib.replaceStrings
      [ "./install" ]
      [ "./install _bin/${stdenv.cc.targetPrefix}c++-opt-sh/oils-for-unix.stripped" ]
      upstream.installPhase
    ;

    configureFlags = upstream.configureFlags ++ [
      "--cxx-for-configure=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
    ];
  });

  # 2025/07/27: upstreaming is blocked on gnome-session (itself blocked on gnome-shell)
  # phosh = prev.phosh.overrideAttrs (upstream: {
  #   buildInputs = upstream.buildInputs ++ [
  #     libadwaita  # "plugins/meson.build:41:2: ERROR: Dependency "libadwaita-1" not found, tried pkgconfig"
  #   ];
  #   mesonFlags = upstream.mesonFlags ++ [
  #     "-Dphoc_tests=disabled"  # "tests/meson.build:20:0: ERROR: Program 'phoc' not found or not executable"
  #   ];
  #   # postPatch = upstream.postPatch or "" + ''
  #   #   sed -i 's:gio_querymodules = :gio_querymodules = "${buildPackages.glib.dev}/bin/gio-querymodules" if True else :' build-aux/post_install.py
  #   # '';
  # });
  # 2024/05/31: upstreaming is blocked on qtsvg, libgweather, webp-pixbuf-loader, appstream, gnome-color-manager, apache-httpd, ibus, freerdp (mostly gnome-shell i think)
  # phosh-mobile-settings = mvInputs {
  #   # fixes "meson.build:26:0: ERROR: Dependency "phosh-plugins" not found, tried pkgconfig"
  #   # phosh is used only for its plugins; these are specified as a runtime dep in src.
  #   # it's correct for them to be runtime dep: src/ms-lockscreen-panel.c loads stuff from
  #   buildInputs = [ phosh ];
  #   nativeBuildInputs = [
  #     gettext  # fixes "data/meson.build:1:0: ERROR: Program 'msgfmt' not found or not executable"
  #     wayland-scanner  # fixes "protocols/meson.build:7:0: ERROR: Program 'wayland-scanner' not found or not executable"
  #     glib  # fixes "src/meson.build:1:0: ERROR: Program 'glib-mkenums mkenums' not found or not executable"
  #     desktop-file-utils  # fixes "meson.build:116:8: ERROR: Program 'update-desktop-database' not found or not executable"
  #   ];
  # } prev.phosh-mobile-settings;

  # pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
  #   (pyself: pysuper: {
  #     # 2025/07/23: upstreaming is unblocked, but solution is untested.
  #     # the references here are a result of the cython build process.
  #     # cython is using the #include files from the build python, and leaving those paths in code comments.
  #     # better solution is to get cython to use the HOST python??
  #     #
  #     # python3Packages.srsly is required by `newelle` program.
  #     srsly = pysuper.srsly.overridePythonAttrs (upstream: {
  #       nativeBuildInputs = (upstream.nativeBuildInputs or []) ++ [
  #         removeReferencesTo
  #       ];
  #       postFixup = (upstream.postFixup or "") + ''
  #         remove-references-to -t ${pyself.python.pythonOnBuildForHost} $out/${pyself.python.sitePackages}/srsly/msgpack/*.cpp
  #       '';
  #     });
  #   })
  # ];

  # qt6 = prev.qt6.overrideScope (self: super: {
  #   # qtbase = super.qtbase.overrideAttrs (upstream: {
  #   #   # cmakeFlags = upstream.cmakeFlags ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
  #   #   cmakeFlags = upstream.cmakeFlags ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
  #   #     # "-DCMAKE_CROSSCOMPILING=True" # fails to solve QT_HOST_PATH error
  #   #     "-DQT_HOST_PATH=${buildPackages.qt6.full}"
  #   #   ];
  #   # });
  #   # qtModule = args: (super.qtModule args).overrideAttrs (upstream: {
  #   #   # the nixpkgs comment about libexec seems to be outdated:
  #   #   # it's just that cross-compiled syncqt.pl doesn't get its #!/usr/bin/env shebang replaced.
  #   #   preConfigure = lib.replaceStrings
  #   #     ["${lib.getDev self.qtbase}/libexec/syncqt.pl"]
  #   #     ["perl ${lib.getDev self.qtbase}/libexec/syncqt.pl"]
  #   #     upstream.preConfigure;
  #   # });
  #   # # qtwayland = super.qtwayland.overrideAttrs (upstream: {
  #   # #   preConfigure = "fixQtBuiltinPaths . '*.pr?'";
  #   # # });
  #   # # qtwayland = super.qtwayland.override {
  #   # #   inherit (self) qtbase;
  #   # # };

  #   qtwebengine = super.qtwebengine.overrideAttrs (upstream: {
  #     # depsBuildBuild = upstream.depsBuildBuild or [] ++ [ pkg-config ];
  #     # XXX: qt seems to use its own terminology for "host" and "target":
  #     # - <https://www.qt.io/blog/qt6-development-hosts-and-targets>
  #     # - "host" = machine invoking the compiler
  #     # - "target" = machine on which the resulting qtwebengine.so binaries will run
  #     # XXX: NIX_CFLAGS_COMPILE_<machine> is how we get the `-isystem <dir>` flags.
  #     #      probably we shouldn't blindly copy these from host machine to build machine,
  #     #      as the headers could reasonably make different assumptions.
  #     preConfigure = upstream.preConfigure + ''
  #       # export PKG_CONFIG_HOST="$PKG_CONFIG"
  #       export PKG_CONFIG_HOST="$PKG_CONFIG_FOR_BUILD"
  #       # expose -isystem <zlib> to x86 builds
  #       export NIX_CFLAGS_COMPILE_x86_64_unknown_linux_gnu="$NIX_CFLAGS_COMPILE"
  #       export NIX_LDFLAGS_x86_64_unknown_linux_gnu="-L${buildPackages.zlib}/lib"
  #     '';
  #     patches = upstream.patches or [] ++ [
  #       # ./qtwebengine-host-pkg-config.patch
  #       # alternatively, look at dlopenBuildInputs
  #       ./qtwebengine-host-cc.patch
  #     ];
  #     # patch the qt pkg-config script to show us more debug info
  #     postPatch = upstream.postPatch or "" + ''
  #       sed -i s/options.debug/True/g src/3rdparty/chromium/build/config/linux/pkg-config.py
  #     '';
  #     nativeBuildInputs = upstream.nativeBuildInputs ++ [
  #       bintools-unwrapped  # for readelf
  #       buildPackages.cups  # for cups-config
  #       buildPackages.fontconfig
  #       buildPackages.glib
  #       buildPackages.harfbuzz
  #       buildPackages.icu
  #       buildPackages.libjpeg
  #       buildPackages.libpng
  #       buildPackages.libwebp
  #       buildPackages.nss
  #       # gcc-unwrapped.libgcc  # for libgcc_s.so
  #       buildPackages.zlib
  #     ];
  #     depsBuildBuild = upstream.depsBuildBuild or [] ++ [ pkg-config ];
  #     # buildInputs = upstream.buildInputs ++ [
  #     #   gcc-unwrapped.libgcc  # for libgcc_s.so. this gets loaded during build, suggesting i surely messed something up
  #     # ];
  #     # buildInputs = upstream.buildInputs ++ [
  #     #   gcc-unwrapped.libgcc
  #     # ];
  #     # nativeBuildInputs = upstream.nativeBuildInputs ++ [
  #     #   icu
  #     # ];
  #     # buildInputs = upstream.buildInputs ++ [
  #     #   icu
  #     # ];
  #     # env.NIX_DEBUG="1";
  #     # env.NIX_DEBUG="7";
  #     # cmakeFlags = lib.remove "-DQT_FEATURE_webengine_system_icu=ON" upstream.cmakeFlags;
  #     cmakeFlags = upstream.cmakeFlags ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
  #       # "--host-cc=${buildPackages.stdenv.cc}/bin/cc"
  #       # "--host-cxx=${buildPackages.stdenv.cc}/bin/c++"
  #       # these are my own vars, used by my own patch
  #       "-DCMAKE_HOST_C_COMPILER=${buildPackages.stdenv.cc}/bin/gcc"
  #       "-DCMAKE_HOST_CXX_COMPILER=${buildPackages.stdenv.cc}/bin/g++"
  #       "-DCMAKE_HOST_AR=${buildPackages.stdenv.cc}/bin/ar"
  #       "-DCMAKE_HOST_NM=${buildPackages.stdenv.cc}/bin/nm"
  #     ];
  #   });
  # });

  # 2026/01/27: upstreaming is unblocked
  # squeekboard = prev.squeekboard.overrideAttrs (upstream: {
  #   # fixes: "meson.build:1:0: ERROR: 'rust' compiler binary not defined in cross or native file"
  #   # new error: "meson.build:1:0: ERROR: Rust compiler rustc --target aarch64-unknown-linux-gnu -C linker=aarch64-unknown-linux-gnu-gcc can not compile programs."
  #   # NB(2023/03/04): upstream nixpkgs has a new squeekboard that's closer to cross-compiling; use that
  #   # NB(2023/08/24): this emulates the entire rust build process
  #   mesonFlags =
  #     let
  #       # ERROR: 'rust' compiler binary not defined in cross or native file
  #       crossFile = writeText "cross-file.conf" ''
  #         [binaries]
  #         rust = [ 'rustc', '--target', '${stdenv.hostPlatform.rust.rustcTargetSpec}' ]
  #       '';
  #     in
  #       # upstream.mesonFlags or [] ++
  #       [
  #         "-Dtests=false"
  #         "-Dnewer=true"
  #         "-Donline=false"
  #       ]
  #       ++ lib.optional
  #         (stdenv.hostPlatform != stdenv.buildPlatform)
  #         "--cross-file=${crossFile}"
  #       ;

  #   # cargoDeps = null;
  #   # cargoVendorDir = "vendor";

  #   # depsBuildBuild = (upstream.depsBuildBuild or []) ++ [
  #   #   pkg-config
  #   # ];
  #   # this is identical to upstream, but somehow build fails if i remove it??
  #   nativeBuildInputs = [
  #     meson
  #     ninja
  #     pkg-config
  #     glib
  #     wayland
  #     rustPlatform.cargoSetupHook
  #     cargo
  #     rustc
  #   ];
  # });

  # 2026/01/03: upstreaming is unblocked
  # tangram = prev.tangram.overrideAttrs (upstream: {
  #   # gsjpack has a shebang for the host gjs. patchShebangs --build doesn't fix that: just manually specify the build gjs.
  #   # the proper way to patch this for nixpkgs is:
  #   # 1. split `gjspack` into its own package.
  #   #   - right now it's a submodule of all of sonnyp's repos,
  #   #     and each nix package re-builds it (forge-sparks, junction, tangram).
  #   # 2. wrap `gjspack` the same way i did blueprint-compiler, and put it in nativeBuildInputs
  #   postPatch = let
  #     gjspack' = buildPackages.writeShellScriptBin "gjspack" ''
  #       export GI_TYPELIB_PATH=${typelibPath [ buildPackages.glib ]}:$GI_TYPELIB_PATH
  #       exec ${buildPackages.gjs}/bin/gjs $@
  #     '';
  #   in (upstream.postPatch or "") + ''
  #     substituteInPlace src/meson.build \
  #       --replace-fail "find_program('gjs').full_path()" "'${gjs}/bin/gjs'" \
  #       --replace-fail "gjspack,"  "'${gjspack'}/bin/gjspack', '-m', gjspack,"
  #   '';
  #   # postPatch = (upstream.postPatch or "") + ''
  #   #   substituteInPlace src/meson.build \
  #   #     --replace-fail "find_program('gjs').full_path()" "'${gjs}/bin/gjs'" \
  #   #     --replace-fail "gjspack," "'env', 'GI_TYPELIB_PATH=${typelibPath [
  #   #       buildPackages.glib
  #   #     ]}', '${buildPackages.gjs}/bin/gjs', '-m', gjspack,"
  #   # '';
  # });

  # fixes: "ar: command not found"
  # `ar` is provided by bintools
  # 2026/01/27: upstreaming is blocked on gnustep-base cross compilation
  # unar = addNativeInputs [ bintools ] prev.unar;

  # unixODBCDrivers = prev.unixODBCDrivers // {
  #   # TODO: should this package be deduped with toplevel psqlodbc in upstream nixpkgs?
  #   # N.B.: psqlodbc is a WAY MORE DIFFICULT PACKAGE TO GET CROSS COMPILING
  #   # - even after fixing configurePhase to actually find all its shit, there are actual C compilation errors like
  #   #   > misc.h:23:17: error: conflicting types for 'strlcat';
  #   psql = prev.unixODBCDrivers.psql.overrideAttrs (_upstream: {
  #     # XXX: these are both available as configureFlags, if we prefer that (we probably do, so as to make them available only during specific parts of the build).
  #     ODBC_CONFIG = buildPackages.writeShellScript "odbc_config" ''
  #       exec ${stdenv.hostPlatform.emulator buildPackages} ${unixODBC}/bin/odbc_config $@
  #     '';
  #     PG_CONFIG = buildPackages.writeShellScript "pg_config" ''
  #       exec ${stdenv.hostPlatform.emulator buildPackages} ${postgresql}/bin/pg_config $@
  #     '';
  #   });
  # };

  # 2025/12/07: upstreaming is blocked on h5py, pyarrow/arrow-cpp, thrift, apache-orc, google-cloud-cpp
  # visidata = prev.visidata.override {
  #   # hdf5 / h5py don't cross-compile, but i don't use that file format anyway.
  #   # setting this to null means visidata will work as normal but not be able to load hdf files.
  #   h5py = null;
  # };
  # 2025/12/07: upstreaming is blocked on qtsvg, qtx11extras
  # vlc = prev.vlc.overrideAttrs (orig: {
  #   # fixes: "configure: error: could not find the LUA byte compiler"
  #   # fixes: "configure: error: protoc compiler needed for chromecast was not found"
  #   nativeBuildInputs = orig.nativeBuildInputs ++ [ lua5 protobuf ];
  #   # fix that it can't find the c compiler
  #   # makeFlags = orig.makeFlags or [] ++ [ "CC=${prev.stdenv.cc.targetPrefix}cc" ];
  #   env = orig.env // {
  #     BUILDCC = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  #   };
  # });

  # 2025/12/07: upstreaming is unblocked
  # fixes `hostPrograms.moby.neovim` (but breaks eval of `hostPkgs.moby.neovim` :o)
  # wrapNeovimUnstable = neovim: config: (prev.wrapNeovimUnstable neovim config).overrideAttrs (upstream: {
  #   # nvim wrapper has a sanity check that the plugins will load correctly.
  #   # this is effectively a check phase and should be rewritten as such
  #   postBuild = lib.replaceStrings
  #     [ "! $out/bin/nvim-wrapper" ]
  #     # [ "${stdenv.hostPlatform.emulator buildPackages} $out/bin/nvim-wrapper" ]
  #     [ "false && $out/bin/nvim-wrapper" ]
  #     upstream.postBuild;
  # });

  # 2026/01/27: upstreaming is unblocked
  xdg-desktop-portal-phosh = prev.xdg-desktop-portal-phosh.overrideAttrs (orig: {
    postPatch = (orig.postPatch or "") + ''
      substituteInPlace src/meson.build --replace-fail \
        "'src' / cargo_target / pmp_exe_name" \
        "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / cargo_target / pmp_exe_name"

      substituteInPlace subprojects/pfs/src/meson.build --replace-fail \
        "'src' / rust_target" \
        "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target"
    '';
    nativeBuildInputs = orig.nativeBuildInputs ++ [
      pkgs.glib
    ];
    env = (orig.env or {}) // {
      CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
    };
  });

  # yt-dlp = let
  #   # XXX(2026-02-04): yt-dlp accepts one of 4 JS runtimes, in order:
  #   # - deno
  #   # - nodejs
  #   # - quickjs (a.k.a. quickjs-ng)
  #   # - bun
  #   # nixpkgs allows providing any of these simply by overriding the `deno` callpackage argument,
  #   # but yt-dlp only actually checks for `deno` unless configured otherwise (i guess there's some runtime config?)
  #   # jsRuntime = final.deno;  #< 2026-02-04: doesn't cross compile
  #   jsRuntime = final.nodejs;  #< 2026-02-04: runtime error: "WARNING: [youtube] [jsc] Error solving n challenge request using "node" provider: Error running node process (returncode: 1): found 0 sig function possibilities."
  #   # jsRuntime = final.quickjs-ng; #< 2026-02-04: runtime error: "WARNING: [youtube] [jsc] Error solving n challenge request using "quickjs" provider: Error running QuickJS process (returncode: 1): found 0 sig function possibilities"
  #   # jsRuntime = final.bun;  #< 2026-02-04: doesn't cross compile
  #   #
  #   # TODO: just fix deno cross compilation and drop this overlay: it's unclear if it actually works.
  #   jsRuntimeYtdlpName = {
  #     deno = "deno";
  #     node = "node";
  #     qjs = "quickjs";
  #     bun = "bun";
  #   }.${jsRuntime.meta.mainProgram};
  # in
  #   (prev.yt-dlp.override {
  #     deno = jsRuntime;
  #   }).overrideAttrs (upstream: {
  #     postPatch = (upstream.postPatch or "") + ''
  #       substituteInPlace yt_dlp/YoutubeDL.py \
  #         --replace-fail \
  #           "self.params.get('js_runtimes', {'deno': {}})" \
  #           "self.params.get('js_runtimes', {'${jsRuntimeYtdlpName}': {}})"
  #       substituteInPlace yt_dlp/options.py \
  #         --replace-fail \
  #           "default=['deno']" \
  #           "default=['${jsRuntimeYtdlpName}']"
  #     '';
  #   });
  # yt-dlp = prev.yt-dlp.override {
  #   # TODO(2025-11-17): yt-dlp needs deno (JavaScript) for full capability:
  #   # <https://github.com/NixOS/nixpkgs/pull/460892>
  #   javascriptSupport = false;  # a.k.a.: `deno = null;`
  # };

  # 2023/12/10: zbar barcode scanner: used by megapixels, frog.
  # the video component does not cross compile (qt deps), but i don't need that.
  # N.B.: if desired, the "video" portion (zbarcam-gtk, zbarcam-qt) can be built for only gtk, by configuring with `--without-qt`.
  # 2026/01/27: still broken upstream
  zbar = prev.zbar.override { enableVideo = false; };
}
