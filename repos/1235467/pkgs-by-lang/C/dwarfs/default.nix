{ lib
, fetchFromGitHub
, stdenv
, bison
, boost
, brotli
, cmake
, double-conversion
, fmt
, fuse3
, flac
, glog
, howard-hinnant-date
, jemalloc
, libarchive
, libevent
, libunwind
, lz4
, openssl
, pkg-config
, python3
, range-v3
, ronn
, xxHash
, utf8cpp
, zstd
, parallel-hashmap
, nlohmann_json
, libdwarf
, versionCheckHook
,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwarfs";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "mhx";
    repo = "dwarfs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-OEA8TwnA+HPi/KaeFiuy2zD+PwKsougnuxPVL5/Xf9g=";
  };

  cmakeFlags = [
    "-DNIXPKGS_DWARFS_VERSION_OVERRIDE=v${finalAttrs.version}" # see https://github.com/mhx/dwarfs/issues/155
    # Upstream composes DESTDIR + CMAKE_INSTALL_PREFIX + CMAKE_INSTALL_SBINDIR
    # in a create_link() install script. Keep SBINDIR relative to avoid
    # nested nix/store path creation in the output.
    "-DCMAKE_INSTALL_SBINDIR=sbin"
    "-DWITH_LEGACY_FUSE=ON"
    "-DWITH_TESTS=OFF"
  ];

  nativeBuildInputs = [
    bison
    cmake
    howard-hinnant-date # uses only the header-only parts
    pkg-config
    range-v3 # header-only library
    ronn
    (python3.withPackages (ps: [ ps.mistletoe ])) # for man pages
  ];

  buildInputs = [
    # dwarfs
    parallel-hashmap
    nlohmann_json
    boost
    brotli
    flac # optional; allows automatic audio compression
    fmt
    fuse3
    jemalloc
    libarchive
    lz4
    xxHash
    utf8cpp
    zstd

    # folly
    double-conversion
    glog
    libevent
    libunwind
    openssl
    libdwarf # DWARFS_STACKTRACE_ENABLED relies on FOLLY_USE_SYMBOLIZER, which needs FOLLY_HAVE_DWARF
  ];

  doCheck = false;
  dontMoveSbin = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/dwarfs";

  meta = {
    description = "Fast high compression read-only file system";
    homepage = "https://github.com/mhx/dwarfs";
    changelog = "https://github.com/mhx/dwarfs/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    platforms = lib.platforms.linux;
  };
})
