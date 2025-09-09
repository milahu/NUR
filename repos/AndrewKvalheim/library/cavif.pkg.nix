{ fetchCrate
, lib
, nix-update-script
, rustPlatform
, versionCheckHook

  # Dependencies
, nasm
}:

rustPlatform.buildRustPackage (cavif: {
  pname = "cavif";
  version = "1.6.0";

  src = fetchCrate {
    inherit (cavif) pname version;
    sha256 = "sha256-F2b03x+jklgxa3VcRA3y0wuK7AQ2LJtCEvCa6eFeG3w=";
  };

  cargoHash = "sha256-x/0Kgf8oWjL6m2/8ol32EJpKkWSgBRbdCTay6KYrtzg=";

  nativeBuildInputs = [ nasm ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AVIF image creator in pure Rust";
    homepage = "https://github.com/kornelski/cavif-rs";
    license = lib.licenses.bsd3;
  };
})
