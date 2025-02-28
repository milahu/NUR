# package configures with notes:
# -- Could not find csc
# -- Could not find gacutil
# -- Could not find al
# -- Could not find resgen
# -- Could not find msbuild
# -- Could not find vstool
# -- Could NOT find PythonInterp (missing: PYTHON_EXECUTABLE) (Required is at least version "3.2")
# -- Could NOT find ZLIB (missing: ZLIB_LIBRARY ZLIB_INCLUDE_DIR) (Required is at least version "1.2.3")
# -- Could NOT find TIFF (missing: TIFF_LIBRARY TIFF_INCLUDE_DIR)
# -- Could NOT find OpenJPEG (minimal suitable version: 2.0, recommended version >= 2.3.1). OpenJPEG will be built from sources
# -- OpenJPEG: VERSION = 2.5.0, BUILD = opencv-4.10.0-openjp2-2.5.0
# -- OpenJPEG libraries will be built from sources: libopenjp2 (version "2.5.0")
# -- libva: missing va.h header (VA_INCLUDE_DIR)
# -- IPPICV: Downloading ippicv_2021.11.0_lnx_intel64_20240201_general.tgz from https://raw.githubusercontent.com/opencv/opencv_3rdparty/fd27188235d85e552de31425e7ea0f53ba73ba53/ippicv/ippicv_2021.11.0_lnx_intel64_20240201_general.tgz
# -- Try 1 failed
# -- Could not find OpenBLAS include. Turning OpenBLAS_FOUND off
# -- Could not find OpenBLAS lib. Turning OpenBLAS_FOUND off
# -- Could NOT find Atlas (missing: Atlas_CBLAS_INCLUDE_DIR Atlas_CLAPACK_INCLUDE_DIR Atlas_CBLAS_LIBRARY Atlas_BLAS_LIBRARY Atlas_LAPACK_LIBRARY)
# -- Could NOT find BLAS (missing: BLAS_LIBRARIES)
# -- Could NOT find LAPACK (missing: LAPACK_LIBRARIES)
#     Reason given by package: LAPACK could not be found because dependency BLAS could not be found.
# -- Could NOT find Java (missing: Java_JAVA_EXECUTABLE Java_JAR_EXECUTABLE Java_JAVAC_EXECUTABLE Java_JAVAH_EXECUTABLE Java_JAVADOC_EXECUTABLE)
# -- Could NOT find JNI (missing: JAVA_INCLUDE_PATH JAVA_INCLUDE_PATH2 AWT JVM)
# -- Could NOT find VTK (missing: VTK_DIR)
# -- VTK is not found. Please set -DVTK_DIR in CMake to VTK build directory, or to VTK install subdirectory with VTKConfig.cmake file
# -- ADE: Downloading v0.1.2d.zip from https://github.com/opencv/ade/archive/v0.1.2d.zip
# -- Try 1 failed
# -- Could NOT find GEOTIFF (missing: GEOTIFF_LIBRARY GEOTIFF_INCLUDE_DIR)
# -- CVEXTERN: GEOTIFF not found. Building from source

{
  cmake,
  dotnetCorePackages,
  eigen,
  fetchFromGitHub,
  lapack,
  lib,
  libgeotiff,
  libjpeg,
  libpng,
  libtiff,
  libva,
  mono,
  msbuild,
  openblas,
  openjpeg,
  opencv,
  pkg-config,
  stdenv,
  # vsbuild,
  vtk,
}:
stdenv.mkDerivation rec {
  pname = "emgucv";
  version = "4.10.0";
  src = fetchFromGitHub {
    owner = "emgucv";
    repo = "emgucv";
    rev = version;
    hash = "sha256-0WGXVIJCVnmqtyTzAjHnr8s0oQB9O1DUBFuhym9q+0E=";
    # TODO: use nixpkgs' eigen, harfbuzz, hdf5, opencv, vtk?
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    mono
    msbuild
    # vsbuild
  ];

  buildInputs = [
    dotnetCorePackages.runtime_9_0
    dotnetCorePackages.sdk_9_0
    eigen  #< TODO: doesn't it ship eigen as a submodule?
    lapack
    libgeotiff  #< TODO: necessary?
    libjpeg  #< TODO: necessary?
    libpng
    libtiff
    libva
    openblas
    openjpeg
    opencv
    vtk
  ];

  cmakeOptions = [
    # options set by emgucv platforms/ubuntu/24.04/cmake_configure:
    "-DWITH_CUDA=FALSE"
    "-DOPENCV_DNN_CUDA=FALSE"
    "-DBUILD_SHARED_LIBS=FALSE"
    # -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON -DCMAKE_BUILD_TYPE:STRING="Release" -DCMAKE_INSTALL_PREFIX:STRING="$INSTALL_FOLDER" -DCMAKE_FIND_ROOT_PATH:STRING="$INSTALL_FOLDER" -DCMAKE_CXX_STANDARD:String="17"
    "-DEMGU_CV_WITH_TESSERACT=FALSE"
    "-DBUILD_opencv_3d=FALSE"
    "-DBUILD_opencv_calib=FALSE"
    "-DBUILD_opencv_dnn=FALSE"
    "-DBUILD_opencv_ml=FALSE"
    "-DBUILD_opencv_photo=FALSE"
    "-DBUILD_opencv_features2d=FALSE"
    "-DBUILD_opencv_gapi=FALSE"
    "-DBUILD_opencv_flann=FALSE"
    "-DBUILD_opencv_video=FALSE"
    "-DEMGU_CV_WITH_FREETYPE=FALSE"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=TRUE"
    "-DBUILD_TESTS=FALSE"
    "-DBUILD_PNG=TRUE"
    "-DBUILD_JPEG=TRUE"
    "-DBUILD_WEBP=TRUE"
    "-DBUILD_JASPER=TRUE"
    "-DBUILD_JAVA=FALSE"
    "-DBUILD_TIFF=TRUE"
    "-DBUILD_OPENEXR=TRUE"
    "-DBUILD_ZLIB=TRUE"
    "-DBUILD_PERF_TESTS=FALSE"
    "-DBUILD_opencv_apps=FALSE"
    "-DBUILD_DOCS=FALSE"
    "-DBUILD_opencv_ts=FALSE"
    "-DBUILD_opencv_java=FALSE"
    "-DBUILD_opencv_python2=FALSE"
    "-DBUILD_opencv_python3=FALSE"
    "-DWITH_EIGEN=TRUE"

    # options set by UVtools:
    "-DWITH_V4L=FALSE"
    "-DWITH_FFMPEG=FALSE"
    "-DWITH_GSTREAMER=FALSE"
    "-DWITH_1394=FALSE"
    "-DVIDEOIO_ENABLE_PLUGINS=FALSE"
    "-DBUILD_opencv_videoio=FALSE"
    "-DBUILD_opencv_gapi=FALSE"
    "-DWITH_PROTOBUF=FALSE"
    "-DBUILD_PROTOBUF=FALSE"
  ];

  NIX_CFLAGS_COMPILE = toString [
    "-I${opencv.out}/include/opencv4"
  ];

  # we only need libcvextern.so, and some of the other targets fail to build
  postPatch = lib.concatMapStrings (d: ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'ADD_SUBDIRECTORY(${d})' \
      '# ADD_SUBDIRECTORY(${d})'
  '') [
    "Emgu.Util"
    "Emgu.CV"
    "Emgu.CV.Bitmap"
    "Emgu.CV.Wpf"
    "Emgu.CV.WindowsUI"
    "Emgu.CV.Example"
    "Emgu.CV.Test"
    "Emgu.CV.Cuda"
    "Emgu.CV.OCR"
    "Emgu.CV.Contrib"
    "Emgu.CV.Models"
    "Emgu.CV.Runtime"
    "platforms/nuget"
    "Emgu.CV.Runtime/Maui"
  ];

  meta = {
    description = "A cross platform .Net wrapper to the OpenCV image processing library";
    maintainers = with lib.maintainers; [ colinsane ];
  };
}
