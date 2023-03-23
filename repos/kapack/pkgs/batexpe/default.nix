# This file was generated by https://github.com/kamilchm/go2nix v1.2.1
# then modified manually
{ lib, buildGoPackage, fetchgit
, bash, coreutils, procps, iproute
}:

buildGoPackage rec {
  pname = "batexpe";
  version = "1.2.0";

  goPackagePath = "framagit.org/batsim/batexpe";

  src = fetchgit {
    rev = "v${version}";
    url = "https://framagit.org/batsim/batexpe.git";
    sha256 = "1mr9g78cmyvz0jnx20fnybqb2pqqhg9vdg0vz1g6c9h43rm800hj";
  };

  propagatedBuildInputs = [bash coreutils procps iproute];

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "set of Go tools around Batsim to simplify experiments";
    longDescription = ''
      It includes:
      - robin: manages the execution of one simulation. It is meant to be as
        robust as possible, as it is the core building block to create experiment
        workflows with Batsim.
      - robintest: is a robin wrapper mainly used to test robin.  robintest
        notably allows to specify what (robin/batsim/scheduler) result is
        expected.
      - the multiple commands are just wrappers around the batexpe library
        (written in Go).  This allows users to build their own tools (in Go) with
        decent code reuse.
    '';
    license = licenses.lgpl3;
    broken = false;
    maintainers = with maintainers; [ mickours ];
    platforms = iproute.meta.platforms;
  };
}
