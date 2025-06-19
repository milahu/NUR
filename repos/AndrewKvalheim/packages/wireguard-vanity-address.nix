{ fetchCrate
, lib
, nix-update-script
, rustPlatform
}:

rustPlatform.buildRustPackage (wireguard-vanity-address: {
  pname = "wireguard-vanity-address";
  version = "0.4.0";

  src = fetchCrate {
    inherit (wireguard-vanity-address) pname version;
    sha256 = "sha256-89Xj/hEzHqLQcv6ljALWwZaYOYTTVvXb9Jln1n/vXMM=";
  };

  # Workaround for NixOS/nixpkgs#392872
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = wireguard-vanity-address.src + "/Cargo.lock";
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Find Wireguard VPN keypairs with a specific readable string";
    homepage = "https://github.com/warner/wireguard-vanity-address";
    license = licenses.mit;
  };
})
