{ stdenv
, fetchFromGitHub
, autoreconfHook
, lib
}:

stdenv.mkDerivation rec {
	pname = "cbm";
	version = "0.3.2";

	src = fetchFromGitHub {
		owner = "haakonnessjoen";
		repo = "MAC-Telnet";
    rev = "master";
    sha256 = "";
	};

	nativeBuildInputs = [
    autoreconfHook
	];

  meta = with lib; {
    description = "Open source MAC Telnet client and server for connecting to Mikrotik RouterOS routers and Posix devices using MAC addresses";
    homepage = "http://lunatic.no/2010/10/routeros-mac-telnet-application-for-linux-users/";
    license = licenses.gpl2Only;
    #maintainers = [ ];
    platforms = platforms.all;
  };
}
