{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "nuclei";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YjcvxDCIXHyc/7+lpg29wDrpe8WmQPWbhXvpIpWO17k=";
  };

  vendorSha256 = "sha256-DE2S70Jfd6Vgx7BXGbhSWTbRIbp8cbiuf8bolHCYMxg=";

  modRoot = "./v2";
  subPackages = [
    "cmd/nuclei/"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool for configurable targeted scanning";
    longDescription = ''
      Nuclei is used to send requests across targets based on a template
      leading to zero false positives and providing effective scanning
      for known paths. Main use cases for nuclei are during initial
      reconnaissance phase to quickly check for low hanging fruits or
      CVEs across targets that are known and easily detectable.
    '';
    homepage = "https://github.com/projectdiscovery/nuclei";
    license = licenses.mit;
  };
}