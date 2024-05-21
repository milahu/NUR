{
  buildGoModule,
  lib,
  sources,
  ...
}:
buildGoModule {
  inherit (sources.baidupcs-go) pname version src;
  vendorHash = "sha256-msTlXtidxLTe3xjxTOWCqx/epFT0XPdwGPantDJUGpc=";
  doCheck = false;

  meta = with lib; {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Baidu Netdisk commandline client, mimicking Linux shell file handling commands.";
    homepage = "https://github.com/qjfoidnh/BaiduPCS-Go";
    license = licenses.asl20;
  };
}
