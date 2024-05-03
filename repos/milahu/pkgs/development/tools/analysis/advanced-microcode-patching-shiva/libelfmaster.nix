{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "libelfmaster";
  version = "0.4-alpha-unstable-2023-02-23";

  src = fetchFromGitHub {
    owner = "elfmaster";
    repo = "libelfmaster";
    #rev = "v${version}";
    # fix: error: ‘ELF_SO_IGNORE_VDSO_F’ undeclared
    rev = "3e90b2e152ac7d7d8a63566b6e650b93520406fb";
    hash = "sha256-+sXD6EzONwZxulX+ZgfMBD9fUniooDvh7U9kw6uX0tU=";
  };

  /*
    PL=""
    for flag in $LDFLAGS; do
      if [ "''${flag:0:2}" = "-L" ]; then
        PL+=" ''${flag:2}"
      fi
    done
    echo "PL: ''${PL@Q}"
    sed -i "s|^PL=.*|PL='$PL'|" configure
  */

  postPatch = ''
    # dont search libs in FHS paths
    sed -i "s|^PL=.*|PL=|" configure

    # fix: Checking dynamic libraries.......failed [dl]
    substituteInPlace configure \
      --replace-fail \
        'REQUIRE_LIBRARY="$REQUIRE_LIBRARY dl"' \
        ':' \

    # fix: undefined reference to `__glibc_unlikely'
    #define __glibc_unlikely(cond) __builtin_expect ((cond), 0)
    substituteInPlace include/libelfmaster.h \
      --replace-fail \
        '#define peu_probable __glibc_unlikely' \
        '#define peu_probable(cond) __builtin_expect ((cond), 0)' \
  '';

  dontDisableStatic = true;

  postInstall = ''
    rmdir $out/bin
  '';

  meta = with lib; {
    description = "Secure ELF parsing/loading library for forensics reconstruction of malware, and robust reverse engineering tools";
    homepage = "https://github.com/elfmaster/libelfmaster";
    # https://github.com/elfmaster/libelfmaster/raw/master/src/libelfmaster.c
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
