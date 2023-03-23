{ fetchFromGitLab, buildPythonPackage, lib, writeTextFile
, fetchurl, blas, lapack, scalapack, mpi, fftw-mpi, libxc, libvdwxc
, which, ase, numpy, scipy
} :

assert
  lib.asserts.assertMsg
  (!blas.isILP64)
  "A 32 bit integer implementation of BLAS is required.";

assert
  lib.asserts.assertMsg
  (!lapack.isILP64)
  "A 32 bit integer implementation of LAPACK is required.";

let
  gpawConfig = writeTextFile {
    name = "siteconfig.py";
    text = ''
      # Compiler
      compiler = 'gcc'
      mpicompiler = '${mpi}/bin/mpicc'
      mpilinker = '${mpi}/bin/mpicc'

      # BLAS
      libraries += ['blas']
      library_dirs += ['${blas}/lib']

      # FFTW
      fftw = True
      if fftw:
        libraries += ['fftw3']

      scalapack = True
      if scalapack:
        libraries += ['scalapack']

      # LibXC
      libxc = True
      if libxc:
        xc = '${libxc}/'
        include_dirs += [xc + 'include']
        library_dirs += [xc + 'lib/']
        extra_link_args += ['-Wl,-rpath={xc}/lib'.format(xc=xc)]
        if 'xc' not in libraries:
          libraries.append('xc')

      # LibVDWXC
      libvdwxc = True
      if libvdwxc:
        vdwxc = '${libvdwxc}/'
        extra_link_args += ['-Wl,-rpath=%s/lib' % vdwxc]
        library_dirs += ['%s/lib' % vdwxc]
        include_dirs += ['%s/include' % vdwxc]
        libraries += ['vdwxc']
    '';
  };

  setupVersion = "0.9.20000";
  pawDataSets = fetchurl {
    url = "https://wiki.fysik.dtu.dk/gpaw-files/gpaw-setups-${setupVersion}.tar.gz";
    sha256 = "07yldxnn38gky39fxyv3rfzag9p4lb0xfpzn15wy2h9aw4mnhwbc";
  };

in buildPythonPackage rec {
  pname = "gpaw";
  version = "21.6.0";

  src = fetchFromGitLab  {
    owner = "gpaw";
    repo = pname;
    rev = version;
    sha256 = "0iv7xgrb256m6sq6sd5w4whf635rmvzvlrp9s248qrwb5p98dmg1";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [
    blas
    scalapack
    fftw-mpi
    libxc
    libvdwxc
  ];

  propagatedBuildInputs = [
    ase
    scipy
    numpy
    mpi
  ];

  patches = [ ./SetupPath.patch ];

  postPatch = ''
    substituteInPlace gpaw/__init__.py \
      --subst-var-by gpawSetupPath "$out/share/gpaw/gpaw-setups-${setupVersion}"
  '';

  postInstall = ''
    currDir=$(pwd)
    mkdir -p $out/share/gpaw && cd $out/share/gpaw
    cp ${pawDataSets} gpaw-setups.tar.gz
    tar -xvf $out/share/gpaw/gpaw-setups.tar.gz
    rm gpaw-setups.tar.gz
    cd $currDir
  '';

  doCheck = false;

  preConfigure = ''
    cp ${gpawConfig} siteconfig.py
  '';

  passthru = { inherit mpi; };

  meta = with lib; {
    description = "DFT and beyond within the projector-augmented wave method";
    homepage = "https://wiki.fysik.dtu.dk/gpaw/index.html";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
  };
}
