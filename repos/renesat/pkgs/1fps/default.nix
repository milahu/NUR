{
  lib,
  fetchFromGitHub,
  buildGoModule,
  xorg,
}:
buildGoModule rec {
  pname = "1fps";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "1fpsvideo";
    repo = "1fps";
    rev = "v${version}";
    hash = "sha256-ZWlNvM/Tsa3rT57fE6LdYEs/PUvg5ZJ+C7DITc+0TqU=";
  };

  proxyVendor = true;

  vendorHash = "sha256-q32whfSiwhxkawJdX2DwxE/ozXQ1QTFaxlLxxlQw/uM=";

  buildInputs = [
    xorg.libX11
    xorg.libXtst
    xorg.libXi
  ];

  meta = {
    description = "Encrypted Screen Sharing";
    homepage = "https://1fps.video";
    # license = lib.licenses.custom;
    maintainers = with lib.maintainers; [renesat];
  };
}
