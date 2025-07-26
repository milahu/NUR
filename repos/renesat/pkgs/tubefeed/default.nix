{
  lib,
  fetchFromGitLab,
  buildPythonPackage,
  setuptools,
  aiofiles,
  aiohttp,
  aiosqlite,
  yt-dlp,
  ffmpeg-full,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "tubefeed";
  version = "2.1.6";
  disabled = pythonOlder "3.10";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "troebs";
    repo = "tubefeed";
    tag = version;
    hash = "sha256-fUIJ6Y9htnw7Jhgeae77vOBuSUa84z7+d5ixQ2hS3hU=";
  };

  patches = [
    ./entry_points.patch
    ./datetime_parse_fix.patch
  ];

  build-system = [setuptools];

  pythonRelaxDeps = true;

  dependencies = [
    aiofiles
    aiohttp
    aiosqlite
    yt-dlp
  ];

  postInstall = ''
    wrapProgram $out/bin/tubefeed \
      --prefix PATH : ${lib.makeBinPath [yt-dlp ffmpeg-full]}
  '';

  pythonImportsCheck = [
    "tubefeed"
  ];

  meta = with lib; {
    description = "Seamlessly integrate YouTube with Audiobookshelf";
    homepage = "https://gitlab.com/troebs/tubefeed";
    license = licenses.mit;
    maintainers = with maintainers; [renesat];
  };
}
