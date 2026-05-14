{ lib, buildGoModule, go-bin, pkg-config, gcc, sqlite, src, bifrost-ui }:

let
  version = "1.4.9";
  go = go-bin.versions."1.26.2";
  buildGoModule' = buildGoModule.override { inherit go; };

  localReplaces = ''
        if [ -f transports/go.mod ]; then
          cat >> transports/go.mod <<'EOF'

    replace github.com/maximhq/bifrost/core => ../core
    replace github.com/maximhq/bifrost/framework => ../framework
    replace github.com/maximhq/bifrost/plugins/governance => ../plugins/governance
    replace github.com/maximhq/bifrost/plugins/compat => ../plugins/compat
    replace github.com/maximhq/bifrost/plugins/logging => ../plugins/logging
    replace github.com/maximhq/bifrost/plugins/maxim => ../plugins/maxim
    replace github.com/maximhq/bifrost/plugins/otel => ../plugins/otel
    replace github.com/maximhq/bifrost/plugins/semanticcache => ../plugins/semanticcache
    replace github.com/maximhq/bifrost/plugins/telemetry => ../plugins/telemetry
    EOF
        fi
  '';
in
buildGoModule' {
  pname = "bifrost";
  inherit version src;

  modRoot = "transports";
  subPackages = [ "bifrost-http" ];
  vendorHash = "sha256-kQYfr/KBpBjx5n09ktDpYFBKl4U3aJda4KZV7Gxa7Tc=";

  doCheck = false;

  env.CGO_ENABLED = "1";

  nativeBuildInputs = [ pkg-config gcc ];
  buildInputs = [ sqlite ];

  overrideModAttrs = final: prev: {
    postPatch = (prev.postPatch or "") + localReplaces;
  };

  postPatch = localReplaces;

  preBuild = ''
    rm -rf bifrost-http/ui
    mkdir -p bifrost-http/ui
    if [ -d "${bifrost-ui}/ui" ]; then
      cp -R --no-preserve=mode,ownership,timestamps "${bifrost-ui}/ui/." bifrost-http/ui/
    else
      printf '%s\n' '<!doctype html><meta charset="utf-8"><title>Bifrost</title>' > bifrost-http/ui/index.html
    fi
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "Fastest enterprise AI gateway with adaptive load balancer, cluster mode, guardrails, 1000+ models support";
    homepage = "https://github.com/maximhq/bifrost";
    license = licenses.asl20;
    mainProgram = "bifrost-http";
  };
}
