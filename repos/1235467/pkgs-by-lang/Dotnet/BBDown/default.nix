{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, ffmpeg
, perl
}:

let
  pname = "BBDown";
  version = "1.6.3";

in
buildDotnetModule rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nilaoda";
    repo = "BBDown";
    rev = "1.6.3";
    hash = "sha256-IXSK4XrdDbSbjvx0XsjZqi53mo4tTeFL3p0gegaNCA0=";
  };

  projectFile = "BBDown/BBDown.csproj";
  nugetDeps = ./deps.json;

  postPatch = ''
    perl -0pi -e 's|public readonly static string APP_DIR = Path.GetDirectoryName\(Environment\.ProcessPath\)!\;\r?\n|public readonly static string APP_DIR = Path.GetDirectoryName(Environment.ProcessPath)!;\n        public readonly static string CONFIG_DIR = GetConfigDir();\n\n        private static string GetConfigDir()\n        {\n            var xdgConfigHome = Environment.GetEnvironmentVariable("XDG_CONFIG_HOME");\n            var homeDir = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);\n            var baseConfigDir = !string.IsNullOrWhiteSpace(xdgConfigHome)\n                ? xdgConfigHome\n                : !string.IsNullOrWhiteSpace(homeDir)\n                    ? Path.Combine(homeDir, ".config")\n                    : APP_DIR;\n            var configDir = Path.Combine(baseConfigDir, "BBDown");\n            Directory.CreateDirectory(configDir);\n            return configDir;\n        }\n|g; s|LogDebug\("AppDirectory: \{0\}", APP_DIR\);|LogDebug("AppDirectory: {0}", APP_DIR);\n            LogDebug("ConfigDirectory: {0}", CONFIG_DIR);|g' BBDown/Program.cs

    substituteInPlace BBDown/Program.Methods.cs \
      --replace-fail 'Path.Combine(APP_DIR, "BBDown.data")' 'Path.Combine(CONFIG_DIR, "BBDown.data")' \
      --replace-fail 'Path.Combine(APP_DIR, "BBDownTV.data")' 'Path.Combine(CONFIG_DIR, "BBDownTV.data")' \
      --replace-fail 'Path.Combine(APP_DIR, "BBDownApp.data")' 'Path.Combine(CONFIG_DIR, "BBDownApp.data")' \
      --replace-fail 'Path.Combine(APP_DIR, "BBDown.archives")' 'Path.Combine(CONFIG_DIR, "BBDown.archives")'

    substituteInPlace BBDown/BBDownConfigParser.cs \
      --replace-fail 'Path.Combine(Program.APP_DIR, "BBDown.config")' 'Path.Combine(Program.CONFIG_DIR, "BBDown.config")'

    substituteInPlace BBDown/BBDownLoginUtil.cs \
      --replace-fail 'Path.Combine(Program.APP_DIR, "BBDown.data")' 'Path.Combine(Program.CONFIG_DIR, "BBDown.data")' \
      --replace-fail 'Path.Combine(Program.APP_DIR, "BBDownTV.data")' 'Path.Combine(Program.CONFIG_DIR, "BBDownTV.data")'
  '';

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  dotnetInstallFlags = [
    "-p:PublishAot=false"
    "-p:PublishTrimmed=false"
    "-p:EnableStaticWebAssets=false"
  ];

  executables = [ "BBDown" ];

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    ffmpeg
  ];

  meta = with lib; {
    description = "Bilibili Video Downloader";
    homepage = "https://github.com/nilaoda/BBDown";
    license = licenses.mit;
    mainProgram = "BBDown";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
