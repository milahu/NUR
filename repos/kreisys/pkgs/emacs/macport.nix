{ stdenv, fetchurl, ncurses, pkgconfig, texinfo, libxml2, gnutls, gettext, autoconf, automake
, AppKit, Carbon, Cocoa, IOKit, OSAKit, Quartz, QuartzCore, WebKit
, ImageCaptureCore, GSS, ImageIO # These may be optional
}:

stdenv.mkDerivation rec {
  emacsVersion = "26.3";
  emacsName = "emacs-${emacsVersion}";
  macportVersion = "7.9";
  name = "emacs-mac-${emacsVersion}-${macportVersion}";

  src = fetchurl {
    url  = "mirror://gnu/emacs/${emacsName}.tar.xz";
    hash = "sha256:119ldpk7sgn9jlpyngv5y4z3i7bb8q3xp4p0qqi7i5nq39syd42d";
  };

  macportSrc = fetchurl {
    url  = "ftp://ftp.math.s.chiba-u.ac.jp/emacs/${emacsName}-mac-${macportVersion}.tar.gz";
    hash = "sha256:1g9y3gc286ih8d2nmxi1yrdi9chmj6inahcljkjh7673xwvjhvsv";
  };

  patches = [ ./clean-env.patch ./mac-title-bar.patch ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig autoconf automake ];

  buildInputs = [ ncurses libxml2 gnutls texinfo gettext
    AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
    ImageCaptureCore GSS ImageIO   # may be optional
  ];

  postUnpack = ''
    mv $sourceRoot $name
    tar xzf $macportSrc -C $name --strip-components=1
    mv $name $sourceRoot
  '';

  postPatch = ''
    patch -p1 < patch-mac
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale

    # use newer emacs icon
    cp ${./Emacs.icns} mac/Emacs.app/Contents/Resources/Emacs.icns

    # Fix sandbox impurities.
    substituteInPlace Makefile.in --replace '/bin/pwd' 'pwd'
    substituteInPlace lib-src/Makefile.in --replace '/bin/pwd' 'pwd'
  '';

  configureFlags = [
    "LDFLAGS=-L${ncurses.out}/lib"
    "--with-xml2=yes"
    "--with-gnutls=yes"
    "--with-mac"
    "--with-modules"
    "--enable-mac-app=$$out/Applications"
  ];

  CFLAGS = "-O3";
  LDFLAGS = "-O3 -L${ncurses.out}/lib";

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "The extensible, customizable text editor";
    homepage    = https://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ jwiegley matthewbauer ];
    platforms   = platforms.darwin;

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.  At its
      core is an interpreter for Emacs Lisp, a dialect of the Lisp
      programming language with extensions to support text editing.

      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs
      Lisp code or a graphical interface; a large number of extensions that
      add other functionality, including a project planner, mail and news
      reader, debugger interface, calendar, and more.  Many of these
      extensions are distributed with GNU Emacs; others are available
      separately.

      This is the "Mac port" addition to GNU Emacs 26. This provides a native
      GUI support for Mac OS X 10.6 - 10.12. Note that Emacs 23 and later
      already contain the official GUI support via the NS (Cocoa) port for
      Mac OS X 10.4 and later. So if it is good enough for you, then you
      don't need to try this.
    '';
  };
}
