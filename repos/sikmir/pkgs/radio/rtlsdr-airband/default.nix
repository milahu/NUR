{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fftwFloat,
  lame,
  libconfig,
  libshout,
  pulseaudio,
  rtl-sdr,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtlsdr-airband";
  version = "5.0.9";

  src = fetchFromGitHub {
    owner = "charlie-foxtrot";
    repo = "RTLSDR-Airband";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Rgsxim7FESVt1ZnVJFvVfMqJMgzVCfP1yBDBBO4zEsE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    lame
    libconfig
    libshout
    pulseaudio
    rtl-sdr
    soapysdr
  ];

  cmakeFlags = [ (lib.cmakeBool "NFM" true) ];

  meta = with lib; {
    description = "Multichannel AM/NFM demodulator";
    inherit (finalAttrs.src.meta) homepage;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.linux;
    skip.ci = stdenv.isDarwin;
    broken = true;
  };
})
