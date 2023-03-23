{ stdenv, lib, fetchFromGitLab
, pkg-config, meson, ninja
, wayland, wayland-protocols, cairo, dbus
, pango, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "libdecor";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jadahl";
    repo = "libdecor";
    rev = "${version}";
    hash = "sha256:0qdg3r7k086wzszr969s0ljlqdvfqm31zpl8p5h397bw076zr6p2";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayland
    wayland-protocols
    cairo
    dbus
    pango
    libxkbcommon
  ];

  meta = {
    description = "A client-side decorations library for Wayland client";
    license = lib.licenses.mit;
  };
}
