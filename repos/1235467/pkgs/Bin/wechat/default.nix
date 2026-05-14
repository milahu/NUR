{ stdenv
, fetchurl
, buildFHSEnvBubblewrap
, writeShellScript
, electron
, lib
, scrot
, pkgs
, ...
} @ args:

let
  src = fetchurl {
    url = "https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.weixin/com.tencent.weixin_2.1.5_amd64.deb";
    sha256 = "sha256-vVN7w+oPXNTMJ/g1Rpw/AVLIytMXI+gLieNuddyyIYE=";
  };
  resource = stdenv.mkDerivation rec {
    unpackPhase = ''
      ar x ${src}
    '';
    inherit (fhs) name;

    installPhase = ''
      mkdir -p $out
      tar xf data.tar.xz -C $out
      mv $out/usr/* $out/
      mv $out/opt/apps/com.tencent.weixin/files/weixin/resources/app $out/lib/wechat-uos
      rm -rf $out/opt $out/usr

      # use system scrot
      pushd $out/lib/wechat-uos/packages/main/dist/
      sed -i 's|__dirname,"bin","scrot"|"${scrot}/bin/"|g' index.js
      popd
    '';
  };

  startScript = writeShellScript "wechat-uos" ''
    wechat_pid=`pidof wechat-uos`
    if test $wechat_pid; then
        kill -9 $wechat_pid
    fi

    ${electron}/bin/electron \
      ${resource}/lib/wechat-uos
  '';
  fhs = buildFHSEnvBubblewrap {
    name = "wechat-uos";
    targetPkgs = pkgs:
      with pkgs; [
        #openssl_1_1
        openssl
        resource
      ];
    runScript = startScript;
    unsharePid = false;
  };
in
stdenv.mkDerivation {
  pname = "wechat-uos";
  version = "2.1.5";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    ln -s ${fhs}/bin/wechat-uos $out/bin/wechat-uos
    ln -s ${resource}/share/icons $out/share/icons
  '';

  meta = with lib; {
    description = "WeChat desktop (System Electron) (Packaging script adapted from https://aur.archlinux.org/packages/wechat-uos)";
    homepage = "https://weixin.qq.com/";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
