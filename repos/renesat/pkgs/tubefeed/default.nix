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
  version = "2.1.3";
  disabled = pythonOlder "3.10";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "troebs";
    repo = "tubefeed";
    tag = version;
    hash = "sha256-88+h8AXLnD9PPVGNcdrQWqV79xZTgyZz4pUcNgRJQ0Y=";
  };

  patches = [
    ./entry_points.patch
    ./datetime_parse_fix.patch
  ];

  build-system = [setuptools];

  dependencies = [
    aiofiles
    aiohttp
    aiosqlite
    yt-dlp
  ];

  nativeBuildInputs = [
    yt-dlp
    ffmpeg-full
  ];

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
