{ lib, fetchFromGitHub, buildGoModule, pkgs, ... }:
let
  src = fetchFromGitHub {
    owner = "Neet-NXO";
    repo = "T2D";
    rev = "v1.0.0";
    sha256 = "sha256-rCQAsIjxNsU0mmdzOCuQvD5AwXXrAGDQ9uiN0EXwjlE=";
  };
in
buildGoModule rec {
  pname = "T2D";
  inherit src;
  version = "1.0.0";
  vendorHash = "sha256-BhIT9Wo5isAi+pVhMu0RHXUlL28bM0dn/CkcvRcLo6g=";
  doCheck = false;
  meta = with lib; {
    description = "一个基于 gnet 框架的高性能 UDP Over TCP 转发工具，支持多种加密算法和灵活的配置选项。";
    homepage = "https://github.com/Neet-NXO/T2D";
    #license = licenses.mit;
    #maintainers = with maintainers; [ bcdarwin ];
  };
}
