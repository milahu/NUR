{
  lib,
  sources,
  stdenv,
  fetchurl,
  substituteAll,
  # nginx dependencies
  brotli,
  gd,
  git,
  liburing,
  libxcrypt,
  libxml2,
  libxslt,
  pcre,
  perl,
  quictls,
  which,
  zlib,
  zstd,
  # extra args to make nixpkgs happy
  modules ? [ ],
  ...
}:
let
  patchUseOpensslMd5Sha1 = fetchurl {
    url = "https://github.com/kn007/patch/raw/master/use_openssl_md5_sha1.patch";
    sha256 = "1db5mjkxl6vxg4pic4v6g8bi8q9v5psj8fbjmjls1nfvxpz6nhvr";
  };

  patchUring = fetchurl {
    url = "https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_io_uring.patch";
    sha256 = "1cgpnhyd2kfqvh32yap651snvq1qvxc1cxvyrjc0vvxcw38d14p8";
  };

  patchNixEtag = substituteAll {
    src = ./patches/nix-etag-1.15.4.patch;
    preInstall = ''
      export nixStoreDir="$NIX_STORE" nixStoreDirLen="''${#NIX_STORE}"
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "nginx-lantian";
  inherit (sources.openresty) version src;
  nginxVersion = lib.versions.pad 3 version;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    git
    which
  ];

  buildInputs = [
    brotli
    gd
    liburing
    libxcrypt
    libxml2
    libxslt
    pcre
    perl
    quictls
    zlib
    zstd
  ];

  preConfigure =
    let
      extraSrcs = [
        "nginx-module-stream-sts"
        "nginx-module-sts"
        "nginx-module-vts"
        "nginx-njs"
        "ngx_brotli"
        "stream-echo-nginx-module"
        "zstd-nginx-module"
      ];

      patch = p: "echo ${p} && patch -p1 < ${p}";
    in
    ''
      ${builtins.concatStringsSep "\n" (
        builtins.map (k: "cp -r ${sources."${k}".src} bundle/${k}") extraSrcs
      )}
      chmod -R 755 .
      patchShebangs .

      pushd bundle/nginx-${nginxVersion}
      ${patch patchUseOpensslMd5Sha1}
      ${patch ./patches/nginx-plain.patch}
      ${patch ./patches/nginx-plain-proxy.patch}
      ${patch patchNixEtag}
      ${patch ./patches/nix-skip-check-logs-path.patch}
      ${patch patchUring}
      sed -i 's#"/usr/include/libxml2"#"${libxml2.dev}/include/libxml2"#g' auto/lib/libxslt/conf
      popd

      pushd bundle/ngx_brotli
      rm -rf deps
      substituteInPlace filter/config \
        --replace '$ngx_addon_dir/deps/brotli/c' ${lib.getDev brotli}
      popd

      pushd bundle/stream-echo-nginx-module
      ${patch ./patches/stream-echo-nginx-module.patch}
      popd
    '';

  configureFlags = [
    "--with-threads"
    "--with-file-aio"
    "--with-pcre-jit"
    "--with-http_addition_module"
    "--with-http_auth_request_module"
    "--with-http_gunzip_module"
    "--with-http_gzip_static_module"
    "--with-http_image_filter_module"
    "--with-http_realip_module"
    "--with-http_plain_module"
    "--with-http_ssl_module"
    "--with-http_stub_status_module"
    "--with-http_sub_module"
    "--with-http_v2_module"
    "--with-http_v3_module"
    "--with-http_xslt_module"
    "--with-stream"
    "--with-stream_realip_module"
    "--with-stream_ssl_module"
    "--with-stream_ssl_preread_module"

    "--add-module=bundle/nginx-module-stream-sts"
    "--add-module=bundle/nginx-module-sts"
    "--add-module=bundle/nginx-module-vts"
    "--add-module=bundle/nginx-njs/nginx"
    "--add-module=bundle/ngx_brotli"
    "--add-module=bundle/stream-echo-nginx-module"
    "--add-module=bundle/zstd-nginx-module"
    # "--without-http_encrypted_session_module" # Conflict with quic stuff

    # NixOS paths
    "--http-log-path=/var/log/nginx/access.log"
    "--error-log-path=/var/log/nginx/error.log"
    "--pid-path=/var/log/nginx/nginx.pid"
    "--http-client-body-temp-path=/var/cache/nginx/client_body"
    "--http-proxy-temp-path=/var/cache/nginx/proxy"
    "--http-fastcgi-temp-path=/var/cache/nginx/fastcgi"
    "--http-uwsgi-temp-path=/var/cache/nginx/uwsgi"
    "--http-scgi-temp-path=/var/cache/nginx/scgi"
  ];

  postInstall = ''
    find $out/ -type f -executable -exec strip --strip-all {} \;
    ln -s $out/luajit/bin/luajit $out/bin/luajit-openresty
    ln -s $out/nginx/sbin/nginx $out/bin/nginx
    ln -s $out/nginx/conf $out/conf
    ln -s $out/nginx/html $out/html
  '';

  passthru = {
    inherit modules;
  };

  meta = with lib; {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "OpenResty with Lan Tian modifications";
    homepage = "https://openresty.org";
    license = licenses.bsd2;
  };
}
