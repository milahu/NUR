{ lib, python3Packages }:
with python3Packages;
buildPythonApplication {
  pname = "jjwxcCrawler";
  version = "1.0";

  propagatedBuildInputs = [
    html2text
    pydes
    requests
    tenacity
  ];

  src = ./.;
  meta = with lib; {
    description = "晋江文学城小说爬虫(Android API)";
    homepage = "https://github.com/lyc8503/jjwxcCrawler";
    maintainers = [ ];
  };
}
