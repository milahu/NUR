{lib, stdenv, fetchurl, buildProjectGenerator ? false,
pkg-config, bash,
opencv, gcc, openal, glew, freeglut, freeimage, gst_all_1,  
cairo, libudev0-shim, freetype, fontconfig, libsndfile, curl, libcardiacarrest, alsaLib, udev,
boost, uriparser, rtaudio, xorg, libraw1394, libdrm, openssl, libusb1, gtk3, assimp, glfw, pugixml,
poco, mpg123,
findutils,
...}:
let
  version = "v0.11.2";
in
stdenv.mkDerivation {
  name = "openframeworks-${version}";
  
  src = fetchurl {
    url = "https://openframeworks.cc/versions/v0.11.2/of_v0.11.2_linux64gcc6_release.tar.gz";
    sha256 = "032706s64jiclg2f0g59ni0c5ww068kz2mas1x3m2rvqdjpbw1wr";
  };
  
  buildInputs = [
  	pkg-config 
  	gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-good gst_all_1.gst-plugins-ugly gst_all_1.gst-libav opencv gcc openal glew freeglut freeimage
  	cairo libudev0-shim freetype fontconfig libsndfile curl libcardiacarrest alsaLib udev
  	boost uriparser rtaudio xorg.libXmu xorg.libXxf86vm libraw1394 libdrm openssl libusb1 gtk3 assimp glfw pugixml
  	poco mpg123
  ];
  
  unpackPhase = ''
    mkdir -p $out/
    tar -xzf $src -C $out/ --strip-components 1
  '';
  
  patchPhase = ''
  	sed -i -E 's/#include "RtAudio\.h"/#include "rtaudio\/RtAudio\.h"/' $out/libs/openFrameworks/sound/ofRtAudioSoundStream.cpp;
  	
  	substituteInPlace $out/scripts/linux/compileOF.sh --replace "/usr/bin/env bash" "${bash}/bin/bash"
  	substituteInPlace $out/scripts/linux/compilePG.sh --replace "/bin/bash" "${bash}/bin/bash"

    patch $out/libs/openFrameworksCompiled/project/qtcreator/modules/of/helpers.js ${./qtcreator-find.diff}
    substituteInPlace $out/libs/openFrameworksCompiled/project/qtcreator/modules/of/helpers.js --replace "__FIND_HERE__" "${findutils}/bin/find"

    patch $out/scripts/qtcreator/templates/wizards/openFrameworks/wizard.json ${./qtcreator-folder.diff}
    substituteInPlace $out/scripts/qtcreator/templates/wizards/openFrameworks/wizard.json --replace "__SELF_HERE__" $out

    patch $out/scripts/qtcreator/templates/wizards/openFrameworksUpdate/wizard.json ${./qtcreator-folder.diff}
    substituteInPlace $out/scripts/qtcreator/templates/wizards/openFrameworksUpdate/wizard.json --replace "__SELF_HERE__" $out
  '';
  
  dontConfigure = true;
  
  buildPhase = ''
    cd $out
    $out/scripts/linux/compileOF.sh -j $NIX_BUILD_CORES
    ${if buildProjectGenerator then "" else "#"}$out/scripts/linux/compilePG.sh -j $NIX_BUILD_CORES
  '';
  dontInstall = true;
  dontFixup = true;

  meta = {
    description = "A toolkit for graphics and computational art.";
    longDescription = ''
      Don't install it to your nix profile; it doesn't work like that.
      To set it up for development use:
      - nix-build it to a safe place in your home folder: 
        mkdir -p ~/opt/; nix-build '<nixpkgs>' -A nur.repos.cwyc.openframeworks -o ~/opt/openframeworks
      - Install Qt Creator
      - Run the script to install the Qt Creator plugin to your ~/.config folder:
        [OF DIRECTORY]/scripts/qtcreator/install_template.sh
      - Create a new openframeworks project in Qt Creator. When prompted for your openframeworks folder, selected where you placed it.
      A cleaner package bundled with qtcreator is in the works.
    '';
    homepage = "https://openframeworks.cc/download/";
    license = lib.licenses.mit;
    meta.platforms = lib.platforms.linux;
    broken = true;
  };
}