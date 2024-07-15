{ lib, stdenv, fetchFromGitHub
, python3
, installShellFiles
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fail2ban";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fail2ban";
    repo = "fail2ban";
    rev = version;
    hash = "sha256-0xPNhbu6/p/cbHOr5Y+PXbMbt5q/S13S5100ZZSdylE=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  pythonPath = with python3.pkgs;
    lib.optionals stdenv.isLinux [
      systemd
      pyinotify

      # https://github.com/fail2ban/fail2ban/issues/3787, remove it in the next release
      setuptools
    ];

  preConfigure = ''
    for i in config/action.d/sendmail*.conf; do
      substituteInPlace $i \
        --replace /usr/sbin/sendmail sendmail
    done

    substituteInPlace config/filter.d/dovecot.conf \
      --replace dovecot.service dovecot2.service
  '';

  doCheck = false;

  preInstall = ''
    substituteInPlace setup.py --replace /usr/share/doc/ share/doc/

    # see https://github.com/NixOS/nixpkgs/issues/4968
    ${python3.pythonOnBuildForHost.interpreter} setup.py install_data --install-dir=$out --root=$out
  '';

  postInstall =
    let
      sitePackages = "$out/${python3.sitePackages}";
    in
    ''
      # Add custom filters
      cp ${./filter.d}/*.conf $out/etc/fail2ban/filter.d

      install -m 644 -D -t "$out/lib/systemd/system" build/fail2ban.service
      # Replace binary paths
      sed -i "s#build/bdist.*/wheel/fail2ban.*/scripts/#$out/bin/#g" $out/lib/systemd/system/fail2ban.service
      # Delete creating the runtime directory, systemd does that
      sed -i "/ExecStartPre/d" $out/lib/systemd/system/fail2ban.service

      # see https://github.com/NixOS/nixpkgs/issues/4968
      rm -r "${sitePackages}/etc"

      installManPage man/*.[1-9]

      # This is a symlink to the build python version created by `updatePyExec`, seemingly to assure the same python version is used?
      rm $out/bin/fail2ban-python
      ln -s ${python3.interpreter} $out/bin/fail2ban-python

    '' + lib.optionalString stdenv.isLinux ''
      # see https://github.com/NixOS/nixpkgs/issues/4968
      rm -r "${sitePackages}/usr"
    '';

  meta = with lib; {
    homepage = "https://www.fail2ban.org/";
    description = "A program that scans log files for repeated failing login attempts and bans IP addresses";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco lovek323 ];
  };
}
