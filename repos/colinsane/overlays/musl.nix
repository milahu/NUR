# places to find musl patches:
# - <https://github.com/nixos/nixpkgs/pulls?q=label%3A%226.topic%3A+musl%22+>
# - <https://github.com/nixos/nixpkgs/pulls?q=pkgsMusl>
# - <https://github.com/nixos/nixpkgs/pulls?q=musl>
# - <https://github.com/MatthewCroughan/nixos-musl/blob/master/musl.nix>
# - <https://github.com/MatthewCroughan/nixos-musl/blob/master/musl-llvm.nix>
# - <https://gitlab.alpinelinux.org/alpine/aports>
# - <https://github.com/void-linux/void-packages>
final: prev:
let
  inherit (final)
    applyPatches
    fetchFromGitHub
    fetchpatch
    fetchPypi
    fetchurl
    lib
    overlays
    pkgs
    runCommand
    stdenv
    writeTextFile
  ;
  fetchAports = { path, ... }@args: let
    args' = lib.removeAttrs args [ "path" ];
    # rev = "7b6e6ad2f2be67a5a21e121ea1ea36fbc8d908eb";
    rev = "6f81d97aa6224b73289c6bd444b33e79afc9ea89";
  in fetchpatch (args' // {
    # fetchpatch not fetchurl, to support args like `stripLen = 2;`
    url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/${rev}/${path}";
    # key the name by rev to help the url remain valid as i bulk upgrade
    name = "${rev}-${args'.name or path}";
  });
in
{
  # XXX(2026-01-20): some things (e.g. securityWrapper) build from pkgsStatic, for dubious reasons;
  # `pkgsMusl.pkgsStatic.stdenv` is broken so just redirect it to ordinary `pkgs`.
  # pkgsStatic = final.pkgs;
  #
  # XXX(2026-01-21): in fact some things *rely* on pkgsStatic being static, e.g. `lix` which needs a static, embeddable `busybox`.
  # so create a real + working pkgsStatic set, by recreating it with a gnu build machine.
  pkgsStatic = import pkgs.path {
    overlays = [
      (self': super': {
        pkgsStatic = super';
      })
    ] ++ overlays;
    localSystem = {
      config = lib.systems.parse.tripleFromSystem (stdenv.buildPlatform.parsed // { abi.name = "gnu"; });
    };
    crossSystem = {
      isStatic = true;
      config = lib.systems.parse.tripleFromSystem (
        stdenv.hostPlatform.parsed
      );
      gcc = stdenv.hostPlatform.gcc or { };
    };
  };

  # exposed for debuggability.
  # some packages (e.g. glibc) don't cross compile _from_ musl,
  # but do compile in a glibc-native environment.
  # for that, define `_pkgsGnu` -- akin to `pkgsMusl`.
  # this could maybe be upstreamed.
  _pkgsGnu = import pkgs.path {
    overlays = [
      (self': super': {
        _pkgsGnu = super';
      })
    ] ++ overlays;
    localSystem = {
      config = lib.systems.parse.tripleFromSystem (stdenv.buildPlatform.parsed // { abi.name = "gnu"; });
    };
  };
  # inherit (final._pkgsGnu)
  #   glibc  #< don't inherit this here: causes mass rebuild
  # ;

  # XXX(2026-02-02): a base musl system lacks /dev/input and wifi.
  # this is likely because systemd can't modprobe the appropriate modules.
  # > systemd-modules-load: Failed to initialize libkmod context: Not supported
  # > buffyboard: Can't open /dev/input: No such file or directory
  #
  # Matthew Croughan links this patch for fixing it:
  # - <https://inbox.vuxu.org/musl/20251017-dlopen-use-rpath-of-caller-dso-v1-1-46c69eda1473@iscas.ac.cn/>
  #
  # test before deploying, with:
  # > $ nix-build -A systemd
  # > $ ./result/lib/systemd/systemd-modules-load
  #
  # on success: "Module 'ctr' is built in"
  # on failure: "Failed to initialize libkmod context: Not supported"
  #
  # TODO: scope this down / simplify
  _pkgsSystemd = prev._pkgsSystemd or (import pkgs.path {
    overlays = [
      (final': prev': {
        _pkgsSystemd = prev';  #< prevents infinite recursion; avoid re-defining _pkgsSystemd if we're already inside it.
        musl = prev'.musl.overrideAttrs (upstream: {
          patches = (upstream.patches or []) ++ [
            (prev.fetchpatch {
              # <https://inbox.vuxu.org/musl/20251017-dlopen-use-rpath-of-caller-dso-v1-1-46c69eda1473@iscas.ac.cn/>
              # 2026-02-02: allegedly, fixes systemd/kmod, particularly:
              # > $ /nix/store/xxx-systemd-258.2/lib/systemd/systemd-modules-load
              # > Failed to initialize libkmod context: Not supported
              # see also:
              # - <https://github.com/NixOS/nixpkgs/pull/475746>
              name = "ldso: Use rpath of dso of caller in dlopen";
              url = "https://inbox.vuxu.org/musl/20251017-dlopen-use-rpath-of-caller-dso-v1-1-46c69eda1473@iscas.ac.cn/raw";
              hash = "sha256-ltg6Vt2EO8VDb/rMZlniPQNz2Kv4TXFOV+4xfnhJ1+Q=";
            })
          ];
        });
      })
    ] ++ overlays;
    localSystem = stdenv.buildPlatform;
  });

  inherit (final._pkgsSystemd)
    systemd;

  # XXX(2026-01-28): `pkgsMusl.glibc` fails build.
  # buildFHSEnv links in ld.so.conf, ld.so.cache, so let's provide it a real, non-cross glibc.
  # i could try patching this out later, but there's probably a lot more to do here first.
  # e.g. zoom still fails launch with:
  # > /opt/zoom/ZoomLauncher: /lib/libstdc++.so.6: no version information available (required by /opt/zoom/ZoomLauncher)
  # there's a good chance those _are_ needed -- but i could try patching it out later & seeing what works.
  # buildFHSEnvBubblewrap = prev.buildFHSEnvBubblewrap.override (
  # let
  #   limitedUseOfNativeGlibc = final.extend (self': super': {
  #     pkgs = super'.pkgs // {
  #       inherit (self'._pkgsGnu) glibc;
  #     };
  #   });
  # in {
  #   inherit (limitedUseOfNativeGlibc) callPackage;
  #   inherit (limitedUseOfNativeGlibc.pkgs) glibc;
  # });
  # XXX(2026-02-03): this fixes `pkgsMusl.zoom-us` to actually launch & join meetings and such.
  # it has no `musl` anywhere though -- it's ~identical to `_pkgsGnu.zoom-us` itself
  # buildFHSEnvBubblewrap = final._pkgsGnu.buildFHSEnvBubblewrap;

  a52dec = prev.a52dec.overrideAttrs (upstream: {
    # 2026-02-05: still required
    # 2026-01-28: fix compiler error
    # > getopt.c:403:21: error: too many arguments to function ‘getenv’; expected 0, have 1
    # >   403 |   posixly_correct = getenv ("POSIXLY_CORRECT");
    # >       |                     ^~~~~~  ~~~~~~~~~~~~~~~~~
    # > getopt.c:211:14: note: declared here
    # >   211 | extern char *getenv ();
    patches = (upstream.patches or []) ++ [
      (fetchAports {
        path = "community/a52dec/gcc-15.patch";
        hash = "sha256-tcIM7vvF0OVD0EP7A9RAd9rTtFUBkH5si7iUgr9iOtY=";
      })
    ];
  });

  # Alyssa Ross tried to upstream this earlier, stalled:
  # - <https://github.com/NixOS/nixpkgs/pull/379174>
  # accountsservice = prev.accountsservice.overrideAttrs (upstream: {
  #   patches = (upstream.patches or []) ++ [
  #     # 2026-01-28: doesn't apply cleanly...
  #     # (fetchurl {
  #     #   name = "daemon-use-portable-fgetspent";
  #     #   url = "https://gitlab.freedesktop.org/accountsservice/accountsservice/-/commit/995a036b7cff6329e2db30bf923c34b4eee40f77.patch?full_index=1";
  #     #   hash = "sha256-HeficBEf+TcdWUjFYl2SExue+lmZ5BS8u8+qy2jytik=";
  #     # })
  #     # 2026-01-28: causes other build failures...
  #     (fetchAports {
  #       path = "community/accountsservice/musl-fgetspent_r.patch";
  #       hash = "sha256-Zvl4H0jqA9yx3IazNPx4SsMEAheEDcxSYxTdIvtzX/g=";
  #     })
  #     (fetchAports {
  #       path = "community/accountsservice/musl-wtmp.patch";
  #       hash = "sha256-zWDcMFKu9M5NJBwvcGrQHP4EPoDZ0uD2CrNPAQZEK1k=";
  #     })
  #   ];
  # });

  # 2026-01-20: out for PR: <https://github.com/NixOS/nixpkgs/pull/482205>
  # cabextract = prev.cabextract.overrideAttrs (upstream: {
  #   patches = (upstream.patches or []) ++ [
  #     (fetchAports {
  #       name = "gcc-15.patch";
  #       path = "community/cabextract/gcc-15.patch";
  #       hash = "sha256-b+ABENtjENCDgASTAb7es7fzvcBcjdtxZXGuohmFzC4=";
  #     })
  #   ];
  # });

  # 2026-02-05: still required
  # 2026-01-29: dante (SOCKS5 server/client) fails build, but the aerc build doesn't reference it --
  # it's wrapped onto PATH by nixpkgs. so hopefully aerc doesn't _truly_ need it.
  aerc = prev.aerc.override {
    dante = null;
  };

  # 2026-02-04: upstream nixpkgs disables a few tests on aarch64, and a few more for any platform with S3 enabled.
  # alpine disables all python tests, and a few c++ tests:
  # > ctest -j2 --test-dir build-cpp -E "arrow-compute-scalar-temporal-test|arrow-orc-adapter-test|arrow-dataset-dataset-writer-test"
  # the following tests fail, perhaps legitimately, but let's just disable them to make progress.
  arrow-cpp = prev.arrow-cpp.overrideAttrs (upstream: {
    GTEST_FILTER = lib.concatStringsSep ":" ([
      upstream.GTEST_FILTER
    ] ++ [
      "TestStringKernels/0.StrptimeZoneOffset"
      "TestStringKernels/1.StrptimeZoneOffset"
      "TimestampConversion.UserDefinedParsersWithZone"
      "TimestampParser.StrptimeZoneOffset"
    ]);
  });

  # 2026-01-29: tried, but could not fix build
  # dante = prev.dante.overrideAttrs (upstream: {
  #   patches = (upstream.patches or []) ++ [
  #     # > Rbindresvport.c:75:14: error: implicit declaration of function 'bindresvport'; did you mean 'Rbindresvport'? [-Wimplicit-function-declaration]
  #     # >    75 |       return bindresvport(s, _sin);
  #     # >       |              ^~~~~~~~~~~~
  #     # >       |              Rbindresvport
  #     (fetchAports {
  #       path = "community/dante/dante-no-bindresvport.patch";
  #       hash = "sha256-sS7fOPIe4FO3NTcnV2uKv2oGUKzIFXxTpQ5wh+o5F50=";
  #     })
  #   ];

  #   # intentionally wipe the upstream configureFlags, which hardcodes `libc.so.6`
  #   configureFlags = [
  #     "ac_cv_func_sched_setscheduler=no"
  #   ];
  # });

  # 2026-02-05: still required
  # 2026-01-20: knot-dns -> xdp-tools -> emacs-nox -> mailutils.
  # mailutils fails to build, non-trivial to fix; hopefully disabling it here doesn't lose anything.
  emacs-nox = prev.emacs-nox.override {
    withMailutils = false;
  };

  ffmpeg_7 = prev.ffmpeg_7.overrideAttrs {
    # 2026-02-03: two tests fail: tests/data/hls-list.append.m3u8, tests/data/hls-list.m3u8
    # Alpine disables check because "tests/data/hls-lists.append.m3u8 [sic] fails".
    # only applies to ffmpeg_7: nix ffmpeg (8) builds fine.
    doCheck = false;
  };

  # 2026-02-05: still required
  # 2026-01-28: disable malcontent to unblock flatpak: it's some "parental controls" thing?
  # flatpak -> malcontent -> accountsservice (broken).
  flatpak = prev.flatpak.override {
    withMalcontent = false;
  };

  firefox-unwrapped = (prev.firefox-unwrapped.override {
    # nothing wrong with lto/pgo, except that it's slow to build/iterate
    ltoSupport = false;
    pgoSupport = false;
  }).overrideAttrs (upstream: {
    patches = (upstream.patches or []) ++ [
      # (writeTextFile {
      #   # this patch was an attempt to fix the following symptoms, but it doesn't:
      #   # - immediately upon launch and until close, Firefox pegs 100% cpu while spamming the console:
      #   #   > Sandbox: seccomp sandbox violation: pid 88, tid 113, syscall 23, args 20 140041528812544 140041528812672 140041528812800 0 0.
      #   #
      #   # `syscall 23` is `select`.
      #   # it appears that for some reason, `__NR_select` was not being permitted inside the sandbox.
      #   # it's unclear if either:
      #   # A. `__NR_select` is forbidden in both glibc and musl builds, but only musl was making use of it (internally, presumably).
      #   # B. `__NR_select` was allowed in glibc, but not allowed in musl build (due e.g. to some bug in the #ifdef's below).
      #   #
      #   # alternatives to this patch include:
      #   # A. set `MOZ_DISABLE_SOCKET_PROCESS_SANDBOX=1` env var before launching firefox.
      #   # B. set `security.sandbox.socket.process.level = 0` in `about:config`.
      #   name = "sandbox-allow-select.patch";
      #   text = ''
      #     diff --git a/security/sandbox/linux/SandboxFilterUtil.h b/security/sandbox/linux/SandboxFilterUtil.h
      #     index 3e07948c5ac0..34651602c7e7 100644
      #     --- a/security/sandbox/linux/SandboxFilterUtil.h
      #     +++ b/security/sandbox/linux/SandboxFilterUtil.h
      #     @@ -182,27 +182,19 @@ class SandboxPolicyBase : public sandbox::bpf_dsl::Policy {
      #      #  define CASES_FOR_clock_gettime case __NR_clock_gettime
      #      #  define CASES_FOR_clock_getres case __NR_clock_getres
      #      #  define CASES_FOR_clock_nanosleep case __NR_clock_nanosleep
      #      #  define CASES_FOR_pselect6 case __NR_pselect6
      #      #  define CASES_FOR_ppoll case __NR_ppoll
      #      #  define CASES_FOR_futex case __NR_futex
      #      #endif

      #     -#if defined(__NR__newselect)
      #     -#  define CASES_FOR_select \
      #     -    case __NR__newselect:  \
      #     -      CASES_FOR_pselect6
      #     -#elif defined(__NR_select)
      #      #  define CASES_FOR_select \
      #          case __NR_select:      \
      #            CASES_FOR_pselect6
      #     -#else
      #     -#  define CASES_FOR_select CASES_FOR_pselect6
      #     -#endif

      #      #ifdef __NR_poll
      #      #  define CASES_FOR_poll \
      #          case __NR_poll:      \
      #            CASES_FOR_ppoll
      #      #else
      #      #  define CASES_FOR_poll CASES_FOR_ppoll
      #      #endif
      #   '';
      # })
      # (fetchAports {
      #   path = "community/firefox/abseil-cpp.patch";
      #   hash = "sha256-frP7s/QxCiBtUcFS0OxH0BDGL7+5kFMaIfrz/Mezu+g=";
      # })
      # (fetchAports {
      #   path = "community/firefox/bmo-1952657-no-execinfo.patch";
      #   hash = "sha256-qx+999tLg18LrWXoUQB9OiNBZLtiRshmQMmJ9l0BECc=";
      # })
      (fetchAports {
        # 2026-02-03: fixes "/build/firefox-147.0.2/objdir/dist/system_wrappers/sys/single_threaded.h:3:15: fatal error: 'sys/single_threaded.h' file not found"
        path = "community/firefox/bmo-1988166-no-single_threaded-h.patch";
        hash = "sha256-oD/UdVfvOtY+HR5mLExf7ARQfvjpaMd2rOf0EBQ5TyM=";
      })
      # (fetchAports {
      #   path = "community/firefox/fix-fortify-system-wrappers.patch";
      #   hash = "sha256-YK3ZDqftPeMLCW3PRlugN9EzeOaa0Cl787QeGbLKTEo=";
      # })
      # (fetchAports {
      #   path = "community/firefox/fix-lp64.patch";
      #   hash = "sha256-apzFsdn0T4+FRmH/BO051Wm9kBTtWtDi9Vu/SRKTrzE=";
      # })
      # (fetchAports {
      #   path = "community/firefox/fix-rust-target.patch";
      #   hash = "sha256-xFtUIfF+WCt0bXgT3VU5tuuOHHph6uuHGDwZpfcrfhs=";
      # })
      # (fetchAports {
      #   path = "community/firefox/lfs64.patch";
      #   hash = "sha256-CvmtbmslHAIZkXySOuEXeg+FAqfNUUoFY3wVQMaxDRc=";
      # })
      (fetchAports {
        # 2026-02-03: fixes "/nix/store/hsvrmvp1i7k326fpvdrg99gmka863fwi-musl-1.2.5-dev/include/sys/prctl.h:88:8: error: redefinition of 'prctl_mm_map'"
        path = "community/firefox/musl-no-linux-prctl.patch";
        hash = "sha256-Mwyvdqc//WvSn7HqbkCILipl2C9Qo0T3ZQWbYPtGK8A=";
      })
      # (fetchAports {
      #   path = "community/firefox/no-ccache-stats.patch";
      #   hash = "sha256-24+F9bVaY0xdfSmk+WVrNPD5pSoyt5wT2r819Hbp7lY=";
      # })
      # (fetchAports {
      #   path = "community/firefox/rust-lto-thin.patch";
      #   hash = "sha256-scnfIrR8e2gez2JJYeFKwGfnGxR/3gmPyyY0/x5QK9A=";
      # })
      # (fetchAports {
      #   path = "community/firefox/riscv64-no-lto.patch";
      #   hash = "sha256-IZ4j3CHmGT6qiRZsnoKtqbUMzQ32kVJ/9VwTlUyrAHk=";
      # })
      # (fetchAports {
      #   # 2026-02-03: this does NOT fix a runtime issue where Firefox spins one core immediately after launch, until closed
      #   # > [88] Sandbox: Failed to report rejected syscall: EPIPE
      #   # > [88] Sandbox: seccomp sandbox violation: pid 88, tid 113, syscall 23, args 20 140041528812544 140041528812672 140041528812800 0 0.
      #   # see: <https://bugzilla.mozilla.org/show_bug.cgi?id=1657849>
      #   path = "community/firefox/sandbox-sched_setscheduler.patch";
      #   hash = "sha256-dq3QghmwMAPzdYDrNTff2J169ezQ/6OaKMMLKkq/aTQ=";
      # })
      # (fetchAports {
      #   path = "community/firefox/sqlite-ppc.patch";
      #   hash = "sha256-MjjqgjExNlLJ7R8iCshy8qehbciSgF7KMgBx+SX70KE=";
      # })
      # (fetchAports {
      #   path = "community/firefox/widevine.patch";
      #   hash = "sha256-UvH6OADowCZ9qaEsN32WS8ofjIHaNJSP+M5SCwAHDtg=";
      # })
      # (fetchAports {
      #   path = "community/firefox/rust1.90-ppc.patch";
      #   hash = "sha256-+/BVhHGNQrbptzMq7ae+OHvk5m+brPs2gqOos4rnjr8=";
      # })
    ];
  });

  # 2026-02-05: still required
  # 2026-01-29: build fails against glycin 3.0.4
  # >    Compiling glycin v3.0.4
  # > error[E0425]: cannot find function `close_range` in crate `libc`
  # >    --> /build/cargo-deps-vendor/glycin-3.0.4/src/sandbox.rs:250:23
  # >     |
  # > 250 |                 libc::close_range(3, libc::c_uint::MAX, libc::CLOSE_RANGE_CLOEXEC as i32);
  # >     |                       ^^^^^^^^^^^ not found in `libc`
  # >
  # > For more information about this error, try `rustc --explain E0425`.
  # > error: could not compile `glycin` (lib) due to 1 previous error
  # > warning: build failed, waiting for other jobs to finish...
  # > FAILED: [code=101] src/fractal
  # > /nix/store/4lk00h8gz0qmlg6mf1hs1q8zbh95yn61-coreutils-9.9/bin/env CARGO_HOME=/build/source/build/cargo-home /nix/store/x22f9hd7qb1zpf44gl48ydg8invl2mbj-cargo-1.92.0/bin/cargo build --manifest-path /build/source/Cargo.toml --target-dir /build/source/build/cargo-target --release && cp /build/source/build/cargo-target/x86_64-unknown-linux-musl/release/fractal src/fractal
  # > ninja: build stopped: subcommand failed.
  # For full logs, run:
  #         nix log /nix/store/6a9l2n5kv5sbrafar1jljh4qs5xkq5xg-fractal-13.drv
  fractal = prev.fractal.overrideAttrs (upstream: rec {
    patches = (upstream.patches or []) ++ [
      (fetchAports {
        path = "community/fractal/cargo-update-glycin.patch";
        hash = "sha256-qLPsV5lIJHK2BfUhajWB5sNbAXbQ8NVHKgKxx1cqDLc=";
      })
    ];
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (upstream) src;
      inherit patches;
      hash = "sha256-W3fN4j408cPYfkn6oIPwD8E92CQ/GL2lZ9ygjg7tKJY=";
    };
  });

  # 2026-02-05: still required
  # XXX(2026-01-29): taken from aports build flags; gcr probably has some conditional forward declaration of getpass?
  # > ../gcr/console-interaction.c: In function ‘console_interaction_ask_password’:
  # > ../gcr/console-interaction.c:100:11: error: implicit declaration of function ‘getpass’ [-Wimplicit-function-declaration]
  # >   100 |   value = getpass (prompt);
  gcr = prev.gcr.overrideAttrs (upstream: {
    NIX_CFLAGS_COMPILE = (upstream.NIX_CFLAGS_COMPILE or "") + " -D_BSD_SOURCE";
  });

  # 2026-02-05: still required
  gdb = prev.gdb.overrideAttrs (upstream: rec {
    # 2026-01-25: gdb 17.1 fails to build:
    # > In file included from ../../gdb/nds32-tdep.c:43:
    # > ../../gdb/../include/opcode/nds32.h:26:9: error: ‘REG_R8’ redefined [-Werror]
    # >    26 | #define REG_R8          (8)
    # >       |         ^~~~~~
    # > In file included from /nix/store/hsvrmvp1i7k326fpvdrg99gmka863fwi-musl-1.2.5-dev/include/signal.h:48,
    # >                  from ../gnulib/import/signal.h:52,
    # >                  from ../gnulib/import/sys/select.h:118,
    # >                  from /nix/store/hsvrmvp1i7k326fpvdrg99gmka863fwi-musl-1.2.5-dev/include/sys/time.h:9,
    # >                  from ../gnulib/import/sys/time.h:39,
    # >                  from ../gnulib/import/sys/select.h:89,
    # >                  from /nix/store/hsvrmvp1i7k326fpvdrg99gmka863fwi-musl-1.2.5-dev/include/sys/types.h:71,
    # >                  from ../gnulib/import/sys/types.h:39,
    # >                  from ../gnulib/import/stdio.h:58,
    # >                  from ../../gdb/../gdbsupport/common-defs.h:103,
    # >                  from ./../../gdb/defs.h:26,
    # >                  from <command-line>:
    # > /nix/store/hsvrmvp1i7k326fpvdrg99gmka863fwi-musl-1.2.5-dev/include/bits/signal.h:11:9: note: this is the location of the previous definition
    # >    11 | #define REG_R8 REG_R8
    #
    # Alpine is on 16.3, and applies a few patches
    #
    # it seems enough for nix to downgrade to 16.3 **and** build w/ -Wno-error.
    version = "16.3";
    src = fetchurl {
      url = "mirror://gnu/gdb/gdb-${version}.tar.xz";
      hash = "sha256-vPzQlVKKmHkXrPn/8/FnIYFpSSbMGNYJyZ0AQsACJMU=";
    };

    # hardeningDisable = [ "all" ];
    env.NIX_CFLAGS_COMPILE = "-Wno-error";

    # patches = (upstream.patches or []) ++ [
    #   (fetchAports {
    #     path = "main/gdb/musl-signals.patch";
    #     hash = "sha256-oNhI6XFA4kM+iUvwSDFl2N9OufbyJYWzjVRh6gXNRO4=";
    #   })
    #   (fetchAports {
    #     path = "main/gdb/ppc-musl.patch";
    #     hash = "sha256-yBD/nI8i943NQO9URUPmrGzpcU/dZACGxuXZLbB6jnA=";
    #   })
    #   (fetchAports {
    #     path = "main/gdb/ppc-ptregs.patch";
    #     hash = "sha256-+CJfgtRP80lwXvP9w2hYPRNqUkBGOlL/9mUx/gBbSh8=";
    #   })
    # ];
  });

  gmime3 = prev.gmime3.overrideAttrs {
    # alpine builds w/ tests disabled, since 2019.
    # see: <https://github.com/jstedfast/gmime/issues/63>
    doCheck = false;
  };

  # 2026-02-05: still required
  gparted = prev.gparted.override {
    # 2026-01-29: `gpart` (binary which is placed on runtime PATH) does not build for musl.
    # > In file included from gpart.h:23,
    # >                  from gm_hmlvm.c:20:
    # > l64seek.h:30:9: error: unknown type name ‘loff_t’; did you mean ‘off_t’?
    # >    30 | typedef loff_t off64_t;
    # >       |         ^~~~~~
    # >       |         off_t
    # musl appears to build without this, so it may just be not used.
    gpart = null;
  };

  gst_all_1 = prev.gst_all_1.overrideScope (_final': prev': {
    # 2026-02-05: still required
    # XXX(2026-01-28): ffv1 tests timeout. it's some new codec, just disable it.
    # <https://github.com/FFmpeg/FFV1>
    #
    # >      Running unittests src/lib.rs (build/target/x86_64-unknown-linux-musl/debug/deps/gstrswebrtc-1b727e3774204f81)
    # >
    # > running 3 tests
    # > test utils::tests::test_find_smallest_available_ext_id ... ok
    # > test utils::tests::test_deserialize_array ... ok
    # > test utils::tests::test_serialize_meta ... ok
    # >
    # > test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.01s
    # >
    # >      Running unittests src/lib.rs (build/target/x86_64-unknown-linux-musl/debug/deps/gstwebrtchttp-b761b0ba82ee0d97)
    # >
    # > running 0 tests
    # >
    # > test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
    # >
    # > Error: CliError { error: Some(1 target failed:
    # >     `-p gst-plugin-ffv1 --test ffv1dec`), exit_code: 101 }
    # >
    # > 1/1 tests FAIL           947.07s   exit status 1
    # >
    # >
    # > Summary of Failures:
    # >
    # > 1/1 tests FAIL           947.07s   exit status 1
    # >
    # > Ok:                0
    # > Fail:              1
    # >
    # > Full log written to /build/source/build/meson-logs/testlog.txt
    # For full logs, run:
    #        nix log /nix/store/jlj6sglablmw8i7n6xy7ypxflbrd9afq-gst-plugins-rs-0.14.4.drv
    # gst-plugins-rs = prev'.gst-plugins-rs.overrideAttrs {
    #   doCheck = false;
    # };
    gst-plugins-rs = prev'.gst-plugins-rs.override {
      plugins = lib.remove "ffv1" prev'.gst-plugins-rs.selectedPlugins;
    };
  });

  hare = prev.hare.override {
    # hare-wrapper -> hare-hook attempts to build gnu toolchains
    # (pkgsCross.gnu64, pkgsCross.aarch64-multiplatform, pkgsCross.riscv64).
    # but glibc doesn't build with musl, so these fail.
    enableCrossCompilation = false;
  };

  # 2026/01/27: fails hyprland -> hyprcursor -> tomlplusplus (locale tests fail)
  # only `nwg-panel` uses hyprland; `null`ing it seems to Just Work.
  hyprland = null;

  # 2026-02-05: still required
  # 2026-01-25: fails building a test, so disable that test. probably not suitable for upstream.
  ldb = prev.ldb.overrideAttrs (upstream: {
    patches = (upstream.patches or []) ++ [
      (fetchAports {
        path = "main/samba/disable-compile-error-test.patch";
        hash = "sha256-HB2/z4g+pBVcCEgyaYDXnahR89STALLbgFsDujegpY8=";
        stripLen = 2;
      })
    ];
  });

  # 2026-02-05: still required
  # XXX(2026-01-29): one of the tests fail; alpine builds without tests claiming
  # "probably fpmath=sse related failures"
  lib2geom = prev.lib2geom.overrideAttrs {
    doCheck = false;
  };

  # > In file included from cd-paranoia.c:63:
  # > getopt.h:169:12: error: conflicting types for ‘getopt’; have ‘int(void)’
  # >   169 | extern int getopt ();
  # >       |            ^~~~~~
  # > In file included from /nix/store/maa6d7kbflymf5ha1gs3553kvjwkwadn-fortify-headers-1.1alpine3/include/unistd.h:23,
  # >                  from cd-paranoia.c:52:
  # > /nix/store/hsvrmvp1i7k326fpvdrg99gmka863fwi-musl-1.2.5-dev/include/unistd.h:127:5: note: previous declaration of ‘getopt’ with type ‘int(int,  char * const*, const char *)’
  # >   127 | int getopt(int, char * const [], const char *);
  # >       |     ^~~~~~
  # > make[2]: *** [Makefile:466: cd-paranoia.o] Error 1
  libcdio-paranoia = prev.libcdio-paranoia.overrideAttrs (upstream: {
    patches = (upstream.patches or []) ++ [
      (fetchAports {
        path = "community/libcdio-paranoia/gcc15-getopt.patch";
        hash = "sha256-HMzcpOpcwg9ntuVDypQMQ3StZLVj6W3SbevnjoKxRKM=";
      })
    ];
  });

  # 2026-02-05: still required
  # 2026-01-29: fails tests
  # > # Begin functests/test_walkone.sh
  # > # PLATFORM=linuxlike
  # > libfaketime: In parse_ft_string(), failed to parse FAKETIME timestamp.
  # > Please check specification 1 with format %s
  # > out=1  expected=(secs since Epoch) - bad
  #
  # aports uses 0.9.12, nixpkgs is on 0.9.11.
  # nixpkgs PR to update is stalled: <https://github.com/NixOS/nixpkgs/pull/414782>
  #
  # libfaketime is used by `unifont` when building; probably most of its use
  # is build time, so disabling check is reasonably safe.
  libfaketime = prev.libfaketime.overrideAttrs (upstream: rec {
    # version = "0.9.12";
    # src = fetchFromGitHub {
    #   owner = "wolfcw";
    #   repo = "libfaketime";
    #   tag = "v${version}";
    #   hash = "sha256-Hd59b7pc6GIDvRR6EEosr/f8sKuV2q7RU7gDSaGFp3Y=";
    # };

    # patches = (upstream.patches or []) ++ [
    #   (fetchAports {
    #     path = "community/libfaketime/time-t-32-bit.patch";
    #     hash = "sha256-1c8H0eqBv+4IsSULiVYnJubz+cwTYzr2MxsNHZaSyfY=";
    #   })
    # ];

    doCheck = false;
  });

  # 2026-02-05: still required
  # XXX(2026-02-02): pkgsMusl.lixPackageSets.latest.lix just started failing installCheck?
  # > lix:installcheck / functional-gc-auto                                       FAIL
  # > lix:installcheck / functional-build                                         TIMEOUT
  lixPackageSets = prev.lixPackageSets.extend (self: super: {
    # makeLixScope = args: (super.makeLixScope args).overrideScope (self': super': {
    #   lix = super'.lix.overrideAttrs { doInstallCheck = false; };
    # });
    lix_2_94 = super.lix_2_94.overrideScope (self': super': {
      lix = super'.lix.overrideAttrs { doInstallCheck = false; };
    });
  });

  # 2026-02-05: still required
  # XXX(2026-01-22): fix broken 0122 test:
  # > FAIL: test-0112.sh
  # > ==================
  # >
  # > Running test 112
  # > No error printed, but there should be one.
  # > FAIL test-0112.sh (exit status: 3)
  # patch to fix it has been merged upstream; cherry-picked in Alpine.
  logrotate = prev.logrotate.overrideAttrs (upstream: {
    patches = (upstream.patches or []) ++ [
      (fetchurl {
        name = "test-avoid-locale-dependent-errno-string";
        url = "https://github.com/logrotate/logrotate/commit/04b21743980c4e236ca5e8de18173fbd3848573b.patch?full_index=1";
        hash = "sha256-S1G/uiBeUNp0CUWzT3vYWmwVhAklEcnLzgNdUeOd8LQ=";
      })
    ];
  });

  # 2026-02-05: still required
  # 2026-01-29: build fails against glycin 3.0.4
  # > error[E0425]: cannot find function `close_range` in crate `libc`
  # >    --> /build/loupe-deps-49.2-vendor/glycin-3.0.4/src/sandbox.rs:250:23
  # >     |
  # > 250 |                 libc::close_range(3, libc::c_uint::MAX, libc::CLOSE_RANGE_CLOEXEC as i32);
  # >     |                       ^^^^^^^^^^^ not found in `libc`
  # >
  # > For more information about this error, try `rustc --explain E0425`.
  # > error: could not compile `glycin` (lib) due to 1 previous error
  loupe = prev.loupe.overrideAttrs (upstream: rec {
    patches = (upstream.patches or []) ++ [
      (fetchAports {
        path = "community/loupe/glycin-2.0.5.patch";
        hash = "sha256-XhsAZjU3LHdiQEYrCs7zsFVizOWYZIgrkfshl0EoOMA=";
      })
    ];
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit (upstream) src;
      inherit patches;
      hash = "sha256-ZTyLHfmMF8rMVT1RlZ2Nmgm4kPKYHdVqqshI/Fkj/f8=";
    };
  });

  # mailutils = prev.mailutils.overrideAttrs (upstream: {
  #   # nativeCheckInputs = (upstream.nativeCheckInputs or []) ++ [
  #   #   final.coreutils
  #   # ];
  #   # enableParallelBuilding = false;
  #   # enableParallelChecking = false;
  #   doCheck = false;
  # });

  # 2026-02-05: still required
  # 2026-01-20: disable JPAKE functionality because its tests fail on musl.
  # this requires disabling [multi-]threading, as threading implicitly enables jpake features.
  # mbedtls = (prev.mbedtls.override { enableThreading = false; }).overrideAttrs (upstream: {
  #   postConfigure = (upstream.postConfigure or "") + ''
  #     perl scripts/config.pl unset MBEDTLS_ECJPAKE_C
  #   '';
  # });
  mbedtls = prev.mbedtls.overrideAttrs (upstream: {
    # XXX(2026-01-20): intentionally overwriting `upstream.postConfigure`, as a hack equivalent to `mbedtls.override { enableThreading = false; }`;
    # mbedtls does not support `.override` functionality.
    postConfigure = ''
      perl scripts/config.pl unset MBEDTLS_ECJPAKE_C
    '';
  });

  mesa-demos = prev.mesa-demos.overrideAttrs (upstream: {
    patches = (prev.patches or []) ++ [
      (fetchAports {
        path = "community/mesa-demos/uint.patch";
        hash = "sha256-GWRGFOFGeKJXnSS27OMZYlEq53Q9Vx4bOmCo8RNvUJY=";
      })
    ];
  });

  # 2026-02-05: still required
  # 2025-01-25: fails build in vendored getopt, hidden behind a `#if !_GNU` block
  # > getopt.c:362:21: error: too many arguments to function ‘getenv’; expected 0, have 1
  # >   362 |   posixly_correct = getenv ("POSIXLY_CORRECT");
  # >       |                     ^~~~~~  ~~~~~~~~~~~~~~~~~
  # > getopt.c:206:7: note: declared here
  # >   206 | char *getenv ();
  netpbm = prev.netpbm.overrideAttrs (upstream: {
    postPatch = (upstream.postPatch or "") + ''
      substituteInPlace converter/other/fiasco/getopt.c \
        --replace-fail 'char *getenv ();' 'char *getenv (const char *);'
      substituteInPlace converter/other/fiasco/getopt.h \
        --replace-fail 'extern int getopt ();' 'extern char *getenv (const char *);'
    '';
  });

  # 2026-02-05: still required
  nmon = prev.nmon.overrideAttrs (upstream:
    # nmon is a single-file project,
    # compiled in nixpkgs in an extremely non-patchable manner.
    let
      patchedSrc = applyPatches {
        src = runCommand "nmon-src" { } ''
          mkdir $out
          cp ${upstream.src} $out/lmon.c
        '';

        patches = [
          (fetchAports {
            # 2026-01-24: fixes `fatal error: fstab.h: No such file or directory`.
            # fstab.h is a glibc-only thing; not present in musl.
            name = "glibc.patch";
            path = "community/nmon/glibc.patch";
            hash = "sha256-TQq/nyZOYKcLT5kOmzoBWNo3j8DvJY/umPDAL7eWilw=";
          })
        ];
      };
    in
    {
      buildPhase = lib.replaceStrings
        [ "${upstream.src}" ]
        [ "${patchedSrc}/lmon.c" ]
        upstream.buildPhase;
    }
  );

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyself: pysuper: {
      # 2026-02-05: still required
      # XXX(2026-01-29): test_ellipse_arc fails, looks like a legitimate failure (numerical).
      # i use inkscape mostly at build time (for wallpapers), so just disable tests.
      inkex = pysuper.inkex.overridePythonAttrs {
        doCheck = false;
      };

      # 2026-02-05: still required
      netifaces = pysuper.netifaces.overrideAttrs (upstream: {
        patches = (upstream.patches or []) ++ [
          (fetchAports {
            path = "community/py3-netifaces/gcc14.patch";
            hash = "sha256-5p5pwpV1GSyPHN0aA1J8plyB/NvAHb9hqWlepY1Mqpk=";
          })
        ];
      });

      # 2026-02-05: still required
      twisted = pysuper.twisted.overrideAttrs (upstream: {
        # 2026-01-22: no explanation; alpine just hard-disables this hanging test, quite intrusively.
        # the test *does* seem to be flakey? but builds (eventually?) w/o this.
        # patches = (upstream.patches or []) ++ [
        #   (fetchAports {
        #     name = "hanging-test.patch";
        #     path = "community/py3-twisted/hanging-test.patch";
        #     hash = "sha256-iMawFI5ydLZbgGBG6bAQCYNtd0lG8GlfG9VxemVuVPw=";
        #   })
        # ];

        # patch over nixpkgs own faulty patch. it assumes libc.so exists at:
        # "${stdenv.cc.libc}/lib/libc.so.6"
        # but that's only true for glibc.
        postPatch = upstream.postPatch + ''
          substituteInPlace src/twisted/python/_inotify.py --replace-fail \
            "'${stdenv.cc.libc}/lib/libc.so.6'" \
            "'${stdenv.cc.libc}/lib/libc.so'"
          # nixpkgs patched _inotify.py, but not _posixifaces.py -- also used by tests
          substituteInPlace src/twisted/internet/test/_posixifaces.py --replace-fail \
              "find_library(\"c\") or \"\"" "'${stdenv.cc.libc}/lib/libc.so'"
        '';
      });
    })
  ];

  # 2026-02-05: still required
  # XXX(2026-01-28): check fails with:
  # > Running phase: checkPhase
  # > check flags: -j24 test
  # > [0/1] Running tests...
  # > Test project /build/source/build
  # >       Start  1: testatomic
  # >       Start  2: testerror
  # >       Start  3: testevdev
  # >       Start  4: testfile
  # >       Start  5: testfilesystem
  # >       Start  6: testlocale
  # >       Start  7: testplatform
  # >       Start  8: testpower
  # >       Start  9: testqsort
  # >       Start 10: testthread
  # >       Start 11: testtimer
  # >       Start 12: testver
  # >       Start 13: testautomation
  # >  1/13 Test  #1: testatomic .......................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  2/13 Test  #2: testerror ........................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  3/13 Test  #3: testevdev ........................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  4/13 Test  #4: testfile .........................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  5/13 Test  #5: testfilesystem ...................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  6/13 Test  #6: testlocale .......................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  7/13 Test  #7: testplatform .....................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  8/13 Test  #8: testpower ........................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # >  9/13 Test  #9: testqsort ........................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # > 10/13 Test #10: testthread .......................Subprocess aborted***Exception:   0.01 sec
  # > Failed loading SDL3 library.
  # > 
  # > 11/13 Test #11: testtimer ........................Subprocess aborted***Exception:   0.00 sec
  # > Failed loading SDL3 library.
  # > 
  # > 12/13 Test #12: testver ..........................Subprocess aborted***Exception:   0.00 sec
  # > Failed loading SDL3 library.
  # > 
  # > 13/13 Test #13: testautomation ...................Subprocess aborted***Exception:   0.00 sec
  # > Failed loading SDL3 library.
  # > 
  # > 
  # > 0% tests passed, 13 tests failed out of 13
  # > 
  # > Total Test time (real) =   0.01 sec
  # > 
  # > The following tests FAILED:
  # >           1 - testatomic (Subprocess aborted)
  # >           2 - testerror (Subprocess aborted)
  # >           3 - testevdev (Subprocess aborted)
  # >           4 - testfile (Subprocess aborted)
  # >           5 - testfilesystem (Subprocess aborted)
  # >           6 - testlocale (Subprocess aborted)
  # >           7 - testplatform (Subprocess aborted)
  # >           8 - testpower (Subprocess aborted)
  # >           9 - testqsort (Subprocess aborted)
  # >          10 - testthread (Subprocess aborted)
  # >          11 - testtimer (Subprocess aborted)
  # >          12 - testver (Subprocess aborted)
  # >          13 - testautomation (Subprocess aborted)
  # > Errors while running CTest
  # > FAILED: [code=8] CMakeFiles/test.util
  # > cd /build/source/build && /nix/store/4y5szbjgf857wn8603gx77gbznfwqh0q-cmake-4.1.2/bin/ctest
  #
  # alpine builds with tests. TODO: enable `doCheck`!
  sdl2-compat = prev.sdl2-compat.overrideAttrs {
    doCheck = false;
  };

  # XXX(2026-02-03): default `pkgsMusl.slack` fails at launch:
  # > Error loading shared library ld-linux-x86-64.so.2: No such file or directory (needed by /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack)
  # > Error loading shared library ld-linux-x86-64.so.2: No such file or directory (needed by /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/libffmpeg.so)
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/libffmpeg.so: __mbrlen: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/libffmpeg.so: strtoll_l: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/libffmpeg.so: strtoull_l: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __fprintf_chk: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: gnu_get_libc_version: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: backtrace: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __vfprintf_chk: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __res_nclose: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __res_ninit: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: posix_fallocate64: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __longjmp_chk: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __sched_cpualloc: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __sched_cpufree: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __fdelt_chk: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: initstate_r: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: random_r: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __mbrlen: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: strtoll_l: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: strtoull_l: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __register_atfork: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __longjmp_chk: symbol not found
  # > Error relocating /nix/store/d2xqw8dspwxk2bnvgnwfzqj534rvfdj8-slack-4.47.72/lib/slack/slack: __libc_stack_end: symbol not found
  # slack = prev.slack.overrideAttrs (upstream: {
  #   installPhase = lib.replaceStrings
  #     [ "patchelf --set-rpath " ]
  #     [ "patchelf --set-rpath ${final._pkgsGnu.glibc}:" ]
  #     upstream.installPhase;
  # });
  # swapping just asar does not fix:
  # slack = prev.slack.override {
  #   inherit (final.extend (self': _super': {
  #     inherit (self'._pkgsGnu) asar;
  #   })) callPackage;
  #   # inherit (final._pkgsGnu) asar;
  # };
  slack = final._pkgsGnu.slack;

  # glibcLocales is null on musl, but some packages still refer to it.
  # is this sensible? should rather patch those out...
  # glibcLocales = pkgsCross.gnu64.glibcLocales;

  # 2026-02-05: still required
  # XXX(2026-01-21): fortify failures only on musl:
  # > In file included from /nix/store/a7ijnxh5xvipgfx2j4wn7p6ff2an966p-fortify-headers-1.1alpine3/include/strings.h:23,
  # >                  from /nix/store/ci8sxhmyzz9pgqidk2z9zh6ycgcr72bd-musl-1.2.5-dev/include/string.h:59,
  # >                  from /nix/store/a7ijnxh5xvipgfx2j4wn7p6ff2an966p-fortify-headers-1.1alpine3/include/wchar.h:38,
  # >                  from /nix/store/j95zv7f9k6m5gpwna7rzp66w75hshww6-gcc-15.2.0/include/c++/15.2.0/cwchar:49,
  # >                  from /nix/store/j95zv7f9k6m5gpwna7rzp66w75hshww6-gcc-15.2.0/include/c++/15.2.0/bits/postypes.h:42,
  # >                  from /nix/store/j95zv7f9k6m5gpwna7rzp66w75hshww6-gcc-15.2.0/include/c++/15.2.0/iosfwd:44,
  # >                  from /nix/store/j95zv7f9k6m5gpwna7rzp66w75hshww6-gcc-15.2.0/include/c++/15.2.0/ios:42,
  # >                  from /nix/store/j95zv7f9k6m5gpwna7rzp66w75hshww6-gcc-15.2.0/include/c++/15.2.0/istream:42,
  # >                  from /nix/store/j95zv7f9k6m5gpwna7rzp66w75hshww6-gcc-15.2.0/include/c++/15.2.0/sstream:42,
  # >                  from ../snapper/LoggerImpl.h:28,
  # >                  from Client.cc:26:
  # > /nix/store/a7ijnxh5xvipgfx2j4wn7p6ff2an966p-fortify-headers-1.1alpine3/include/stdlib.h:45:1: error: type of ‘snapper::realpath’ is unknown
  # >    45 | _FORTIFY_FN(realpath) char *realpath(const char *__p, char *__r)
  # >       | ^~~~~~~~~~~
  # > In file included from /nix/store/qy1m4630zb53hbipggk0pnzc4h62a2yh-boost-1.87.0-dev/include/boost/thread/detail/thread.hpp:34,
  # >                  from /nix/store/qy1m4630zb53hbipggk0pnzc4h62a2yh-boost-1.87.0-dev/include/boost/thread/thread_only.hpp:22,
  # >                  from /nix/store/qy1m4630zb53hbipggk0pnzc4h62a2yh-boost-1.87.0-dev/include/boost/thread/thread.hpp:12,
  # >                  from /nix/store/qy1m4630zb53hbipggk0pnzc4h62a2yh-boost-1.87.0-dev/include/boost/thread.hpp:13,
  # >                  from ../dbus/DBusConnection.h:29,
  # >                  from Client.cc:30:
  # > /nix/store/a7ijnxh5xvipgfx2j4wn7p6ff2an966p-fortify-headers-1.1alpine3/include/stdlib.h: In function ‘char* realpath(const char*, char*)’:
  # > /nix/store/a7ijnxh5xvipgfx2j4wn7p6ff2an966p-fortify-headers-1.1alpine3/include/stdlib.h:54:40: error: ‘__orig_realpath’ cannot be used as a function
  # >    54 |                 __ret = __orig_realpath(__p, __buf);
  # >       |                         ~~~~~~~~~~~~~~~^~~~~~~~~~~~
  # > /nix/store/a7ijnxh5xvipgfx2j4wn7p6ff2an966p-fortify-headers-1.1alpine3/include/stdlib.h:63:31: error: ‘__orig_realpath’ cannot be used as a function
  # >    63 |         return __orig_realpath(__p, __r);
  # >       |                ~~~~~~~~~~~~~~~^~~~~~~~~~
  snapper = prev.snapper.overrideAttrs {
    # knownHardeningFlags = [
    #   # or special flag "all"
    #   "bindnow"
    #   "format"
    #   "fortify"
    #   "fortify3"
    #   "glibcxxassertions"
    #   "libcxxhardeningextensive"
    #   "libcxxhardeningfast"
    #   "nostrictaliasing"
    #   "pacret"
    #   "pic"
    #   "relro"
    #   "shadowstack"
    #   "stackclashprotection"
    #   "stackprotector"
    #   "strictflexarrays1"
    #   "strictflexarrays3"
    #   "strictoverflow"
    #   "trivialautovarinit"
    #   "zerocallusedregs"
    # ];
    # hardeningDisable = [ "all" ];
    hardeningDisable = [ "fortify" ];
  };

  # 2026-02-05: still required
  # 2026-01-29: fish fails checkPhase on musl, but swaync doesn't seem to actually need it?
  swaynotificationcenter = prev.swaynotificationcenter.override {
    fish = null;
  };

  # 2026-02-05: still required
  # XXX(2026-01-29): fix missing include for posix read/close. TODO: send upstream!
  # > src/backlight.cpp: In lambda function:
  # > src/backlight.cpp:55:39: error: ‘read’ was not declared in this scope; did you mean ‘fread’?
  # >    55 |                         ssize_t ret = read(inotify_fd, buffer, 1024);
  # >       |                                       ^~~~
  # >       |                                       fread
  # > src/backlight.cpp: In destructor ‘syshud_backlight::~syshud_backlight()’:
  # > src/backlight.cpp:69:9: error: ‘close’ was not declared in this scope; did you mean ‘pclose’?
  # >    69 |         close(inotify_fd);
  # >       |         ^~~~~
  # >       |         pclose
  syshud = prev.syshud.overrideAttrs (upstream: {
    patches = (upstream.patches or []) ++ [
      (fetchurl {
        url = "https://git.uninsane.org/colin/syshud/commit/43438f78db47d161ef193325af93146d27eed911.patch?full_index=1";
        hash = "sha256-pWrtmwWBdLfm2c2GmMxJSE7g88y/t6J/fvFXb6L9OJg=";
      })
    ];
  });

  # 2026-02-05: still required
  # 2026-01-29: build failure due to missing include
  # > ifrename.c: In function ‘mapping_getsysfs’:
  # > ifrename.c:1816:15: error: implicit declaration of function ‘basename’ [-Wimplicit-function-declaration]
  # >  1816 |           p = basename(linkpath);
  wirelesstools = prev.wirelesstools.overrideAttrs (upstream: {
    patches = (upstream.patches or []) ++ [
      (fetchAports {
        path = "main/wireless-tools/include-libgen.patch";
        hash = "sha256-HgT04rxtu+Zr+F6xXoc7qIyUXGenGNo72VHDCEGJhXo=";
      })
    ];
  });

  # 2026-02-05: still required
  # 2026-01-28: fix build failure on both nixpkgs master, and on 0.52.0.
  # alpine doesn't need this patch -- why?
  # > ../src/xdg-desktop-portal-phosh.c: In function ‘main’:
  # > ../src/xdg-desktop-portal-phosh.c:150:3: error: implicit declaration of function ‘setlocale’ [-Wimplicit-function-declaration]
  # >   150 |   setlocale (LC_ALL, "");
  # >       |   ^~~~~~~~~
  # > ../src/xdg-desktop-portal-phosh.c:150:3: warning: nested extern declaration of ‘setlocale’ [-Wnested-externs]
  # > ../src/xdg-desktop-portal-phosh.c:150:14: error: ‘LC_ALL’ undeclared (first use in this function)
  # >   150 |   setlocale (LC_ALL, "");
  xdg-desktop-portal-phosh = prev.xdg-desktop-portal-phosh.overrideAttrs (upstream: {
    postPatch = (upstream.postPatch or "") + ''
      sed  -i '1i #include <locale.h>' src/xdg-desktop-portal-phosh.c
      sed  -i '1i #include <locale.h>' src/thumbnailer/service.c
      sed  -i '1i #include <locale.h>' src/thumbnailer/cli.c
    '';
  });

  # 2026-02-05: still required
  # XXX(2026-01-22): v1.6.0 (nixpkgs default) fails to compile:
  # >     CC       xdpsock.o
  # > In file included from /nix/store/ci8sxhmyzz9pgqidk2z9zh6ycgcr72bd-musl-1.2.5-dev/include/net/ethernet.h:10,
  # >                  from xdpsock.c:18:
  # > /nix/store/ci8sxhmyzz9pgqidk2z9zh6ycgcr72bd-musl-1.2.5-dev/include/netinet/if_ether.h:115:8: error: redefinition of ‘struct ethhdr’
  # >   115 | struct ethhdr {
  # >       |        ^~
  # > In file included from xdpsock.c:12:
  # > /nix/store/ci8sxhmyzz9pgqidk2z9zh6ycgcr72bd-musl-1.2.5-dev/include/linux/if_ether.h:173:8: note: originally defined here
  # >   173 | struct ethhdr {
  # >       |        ^~
  # > make[2]: * [Makefile:13: xdpsock.o] Error 1
  # > make[1]: * [Makefile:13: util] Error 2
  # > make: * [Makefile:31: lib] Error 2
  # For full logs, run:
  #     nix log /nix/store/h39j3mh137l8yqmnwr2vh6ijbgv28czf-xdp-tools-1.6.0.drv
  xdp-tools = prev.xdp-tools.overrideAttrs (upstream: rec {
    # 1.6.0+ conflates `linux/if_ether.h` and `netinet/if_ether.h`
    # in a way that's difficult to reconcile 100%
    # NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";
    # postPatch = (upstream.postPatch or "") + ''
    #   find . -type f -exec sed -i 's:linux/if_ether.h:netinet/if_ether.h:g' '{}' ';'

    #   substituteInPlace lib/libxdp/xsk.c \
    #     --replace-fail 'netinet/if_ether.h' 'linux/if_ether.h'

    #   substituteInPlace lib/util/xdp_sample.c \
    #     --replace-fail 'netinet/if_ether.h' 'linux/if_ether.h'

    #   # substituteInPlace lib/util/xdpsock.c \
    #   #   --replace-fail 'linux/if_ether.h' 'netinet/if_ether.h'

    #   # substituteInPlace lib/util/params.h \
    #   #   --replace-fail 'linux/if_ether.h' 'netinet/if_ether.h'

    #   # substituteInPlace lib/util/params.c \
    #   #   --replace-fail 'linux/if_ether.h' 'netinet/if_ether.h'


    #   # substituteInPlace lib/util/xdpsock.h --replace-fail \
    #   #   "#include <netinet/ether.h>" "#include <linux/if_ether.h>"

    #   # substituteInPlace lib/util/xdpsock.c \
    #   #   --replace-fail "#include <netinet/ether.h>" "" \
    #   #   --replace-fail "#include <net/ethernet.h>" ""
    # '';
    # nativeBuildInputs = (upstream.nativeBuildInputs or []) ++ [
    #   final.clang
    # ];
    # preConfigure = (upstream.preConfigure or "") + ''
    #   unset CLANG
    # '';
    # BPF_CFLAGS = "";
    # version = "1.5.7";  #< builds
    # src = fetchFromGitHub {
    #   owner = "xdp-project";
    #   repo = "xdp-tools";
    #   rev = "v${version}";
    #   hash = "sha256-dJMGBFFfEpKO+5ku5Xsc95hGSmTenHGRjBTL7s1cv0c=";
    # };

    version = "1.5.8";  #< builds
    src = fetchFromGitHub {
      owner = "xdp-project";
      repo = "xdp-tools";
      rev = "v${version}";
      hash = "sha256-fW0If34PTGE36KoZYPeKOMuNjaFz1JmSCaWIaSjB0gk=";
    };

    # version = "1.5.8-unstable-20260106";  #< builds
    # src = fetchFromGitHub {
    #   owner = "xdp-project";
    #   repo = "xdp-tools";
    #   rev = "c109ab3175008ffc1c7bdcfc5376c54b5666faf2";
    #   hash = "sha256-VRNFPPGtu+n3WBZTzC7ZIJePhY6VgaDXHYbzHkcM+EU=";
    # };

    #< this region not yet bisected

    # version = "1.5.8-unstable-20250911";  #< fails, `make[1]: *** No rule to make target 'xdp_socket.bpf.c', needed by 'xdp_socket.bpf.o'.  Stop.`
    # src = fetchFromGitHub {
    #   owner = "xdp-project";
    #   repo = "xdp-tools";
    #   rev = "0a4cc7469abe4f9203598c46008000ee4bbbe10f";
    #   hash = "sha256-vZzvFl3bfoGro3hTLnowHkFOI+9JuwO2/78QIOigcTs=";
    # };

    # version = "1.5.8-unstable-20250916";  #< fails, `make[1]: *** No rule to make target 'xdp_socket.bpf.c', needed by 'xdp_socket.bpf.o'.  Stop.`
    # src = fetchFromGitHub {
    #   owner = "xdp-project";
    #   repo = "xdp-tools";
    #   rev = "7028ccef1b62d6b546edd709fc00d7f6ad38a5f1";
    #   hash = "sha256-x0IF24NJNdv6U91fAPazQ8HyX+yW5q29w966eOdzCJQ=";
    # };

    #< this region not yet bisected

    # version = "1.5.8-unstable-20250916";  #< fails
    # src = fetchFromGitHub {
    #   owner = "xdp-project";
    #   repo = "xdp-tools";
    #   rev = "ec02d32f75431b7ed9857cb51c631bc4127f3fb2";
    #   hash = "sha256-dtSHXQEHucZyU/IUIXu5zRee8EMTtfS6R6M2lniI7nE=";
    # };

    # version = "1.5.8-unstable-20251216";  #< fails
    # src = fetchFromGitHub {
    #   owner = "xdp-project";
    #   repo = "xdp-tools";
    #   rev = "bf9ddf088a082141abac3e393c97233c98a39e61";
    #   hash = "sha256-qdGI3BgLiUckPJcz+3VERAA0C3N3ZB3/6lCEe6KkcH0=";
    # };

    # version = "1.6.0-unstable-20260115";  #< fails
    # src = fetchFromGitHub {
    #   owner = "xdp-project";
    #   repo = "xdp-tools";
    #   rev = "6754facf547ccf76c601911ba02c84c238d1748f";
    #   hash = "sha256-qSEPw/UaH7H0A6hT8ipdlCBS+IG/gyErUa3UK9DOEfI=";
    # };
  });


  # 2026-02-05: still required
  # 2026-01-28: disable failing tests:
  # > cd /build/source/build/test && ./test_xsimd
  # > [doctest] doctest version is "2.4.12"
  # > [doctest] run with "--help" for options
  # > ===============================================================================
  # > /build/source/test/test_complex_trigonometric.cpp:198:
  # > TEST CASE:  [complex trigonometric]<xsimd::batch<std::complex<float> >>
  # >   atan
  # > 
  # > /build/source/test/test_complex_trigonometric.cpp:159: ERROR: CHECK_EQ( diff, 0 ) is NOT correct!
  # >   values: CHECK_EQ( 1, 0 )
  # > 
  # > ===============================================================================
  # > /build/source/test/test_complex_trigonometric.cpp:198:
  # > TEST CASE:  [complex trigonometric]<xsimd::batch<std::complex<double> >>
  # >   atan
  # > 
  # > /build/source/test/test_complex_trigonometric.cpp:159: ERROR: CHECK_EQ( diff, 0 ) is NOT correct!
  # >   values: CHECK_EQ( 1, 0 )
  # > 
  # > ===============================================================================
  # > [doctest] test cases:  327 |  325 passed | 2 failed | 0 skipped
  # > [doctest] assertions: 8606 | 8604 passed | 2 failed |
  # > [doctest] Status: FAILURE!
  # > make[3]: *** [test/CMakeFiles/xtest.dir/build.make:70: test/CMakeFiles/xtest] Error 1
  # > make[3]: Leaving directory '/build/source/build'
  # > make[2]: *** [CMakeFiles/Makefile2:246: test/CMakeFiles/xtest.dir/all] Error 2
  # > make[2]: Leaving directory '/build/source/build'
  # > make[1]: *** [CMakeFiles/Makefile2:253: test/CMakeFiles/xtest.dir/rule] Error 2
  # > make[1]: Leaving directory '/build/source/build'
  # > make: *** [Makefile:192: xtest] Error 2
  # > error: builder for '/nix/store/rsav1hbrn8s6xa5zsyanqi8m4l9i6xjp-xsimd-13.2.0.drv' failed with exit code 2;
  xsimd = prev.xsimd.overrideAttrs (upstream: {
    patches = (upstream.patches or []) ++ [
      (fetchAports {
        path = "community/xsimd/failed-tests.patch";
        hash = "sha256-IvbAp/OZU2m6U+jV5xMZLFttGvnlfdkBOSrmYJnBrx8=";
      })
    ];
  });

  # yt-dlp = prev.yt-dlp.override {
  #   # 2026-01-25: deno fails to build for musl.
  #   # >    Compiling encoding_rs v0.8.35
  #   # > error: couldn't read `/build/deno-2.6.5-vendor/v8-142.2.0/gen/src_binding_release_x86_64-unknown-linux-musl.rs`: No such file or directory (os error 2)
  #   # >  --> /build/deno-2.6.5-vendor/v8-142.2.0/src/binding.rs:6:1
  #   # >   |
  #   # > 6 | include!(env!("RUSTY_V8_SRC_BINDING_PATH"));
  #   # >   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  #   # >
  #   # >    Compiling unicode-xid v0.2.6
  #   # > error: could not compile `v8` (lib) due to 1 previous error
  #   javascriptSupport = false;  # a.k.a.: `deno = null;`
  # };

  # XXX(2026-02-03): musl `buildFHSEnvBubblewrap`-based attempt failed at runtime:
  # > /opt/zoom/ZoomLauncher: /lib/libstdc++.so.6: no version information available (required by /opt/zoom/ZoomLauncher)
  zoom-us = final._pkgsGnu.zoom-us;

  # 2026-02-05: still required
  # XXX(2026-01-22): unblocked on staging. fixes `pkgsMusl.zsh` Internal Compiler Error
  # > gcc -c -I. -I../Src -I../Src -I../Src/Zle -I. -I/nix/store/cg1bcbp19ysvzxs4yhjb69wkf35l4v6i-pcre2-10.46-dev/include  -DHAVE_CONFIG_H -Wall -Wmissing-prototypes -O2  -o sort.o sort.c
  # > during GIMPLE pass: objsz
  # > sort.c: In function ‘strmetasort’:
  # > sort.c:234:1: internal compiler error: in check_for_plus_in_loops, at tree-object-size.cc:2158
  # >   234 | strmetasort(char **array, int sortwhat, int *unmetalenp)
  # >       | ^~~~~~~~~~~
  # > 0x22c6d7b diagnostic_context::diagnostic_impl(rich_location*, diagnostic_metadata const*, diagnostic_option_id, char const*, __va_list_tag (*) [1], diagnostic_t)
  # >         ???:0
  # > 0x22d89ba internal_error(char const*, ...)
  # >         ???:0
  # > 0x78d323 fancy_abort(char const*, int, char const*)
  # >         ???:0
  # > 0x76a108 compute_builtin_object_size(tree_node*, int, tree_node**) [clone .cold]
  # >         ???:0
  # > 0x8fac5f fold_builtin_n(unsigned long, tree_node*, tree_node*, tree_node**, int, bool) [clone .isra.0]
  # >         ???:0
  # > 0xae49c1 gimple_fold_stmt_to_constant_1(gimple*, tree_node* (*)(tree_node*), tree_node* (*)(tree_node*))
  # >         ???:0
  # > 0xae50e2 gimple_fold_stmt_to_constant(gimple*, tree_node* (*)(tree_node*))
  # >         ???:0
  # > 0xf3c82c object_sizes_execute(function*, bool)
  # >         ???:0
  # > Please submit a full bug report, with preprocessed source (by using -freport-bug).
  # > Please include the complete backtrace with any bug report.
  # > See <https://gcc.gnu.org/bugs/> for instructions.
  # > make[2]: *** [Makemod:230: sort.o] Error 1
  # > make[2]: Leaving directory '/build/zsh-5.9/Src'
  # > make[1]: *** [Makefile:449: modobjs] Error 2
  # > make[1]: Leaving directory '/build/zsh-5.9/Src'
  # > make: *** [Makefile:188: all] Error 1
  zsh = prev.zsh.overrideAttrs (upstream: {
    hardeningDisable = [ "fortify" ];
  });
}
