{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  pname = "llr";
  version = "0.9.0";
in
  buildGoModule {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "etu";
      repo = pname;
      rev = version;
      sha256 = "sha256-0gWDs6W6Sh5aGd8XG12ZIEwVvhtdRfhAIHjr38BPo8I=";
    };

    vendorSha256 = "14x9ikn9jfldvs8dznzf3xabqw0d9c20gzqggmiy4pca0s9bc34z";

    meta = with lib; {
      description = "llr reads text and truncates it to the terminal width";
      homepage = "https://github.com/etu/${pname}";
      changelog = "https://github.com/etu/${pname}/releases/tag/${version}";
      license = licenses.isc;
      maintainers = [maintainers.etu];
      platforms = platforms.all;
    };
  }
