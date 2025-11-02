{
  stdenv,
  fetchFromGitHub,
  lean4,
  lakeSetupHook,
  writeText,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "wrvsrx";
    repo = "xdg";
    tag = finalAttrs.version;
    hash = "sha256-oCyfOGKk+tjMm1xRmTz90gKW3bXQdBqXvVHbqCuhlO0=";
  };
  env.NIX_LAKE_MANIFEST_OVERRIDE = writeText "lake-manifest-overrided.json" (builtins.toJSON [ ]);
  nativeBuildInputs = [
    lean4
    lakeSetupHook
  ];
})
