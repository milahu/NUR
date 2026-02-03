{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "protoc-gen-connect-openapi";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "sudorandom";
    repo = "protoc-gen-connect-openapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tz9KGY1eAseZWwKamo7VLjocCW3JcJ6UWAI/YsTbECo=";
  };

  vendorHash = "sha256-gtn32Oxjg5LpGpYqPOa62gUUpVcGB4y9RathNdRW8Wg=";

  passthru = {
    updateScript = lib.concatStringsSep " " (nix-update-script {
      extraArgs = [
        "--commit"
        "${finalAttrs.pname}"
      ];
    });
  };

  meta = {
    description = "Protobuf plugin for generating OpenAPI specs matching the Connect RPC interface";
    mainProgram = "protoc-gen-connect-openapi";
    homepage = "https://github.com/sudorandom/protoc-gen-connect-openapi";
    changelog = "https://github.com/sudorandom/protoc-gen-connect-openapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
