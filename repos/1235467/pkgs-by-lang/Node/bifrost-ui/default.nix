{ lib, buildNpmPackage, src, version }:

buildNpmPackage {
  pname = "bifrost-ui";
  inherit version src;
  sourceRoot = "source/ui";

  npmDepsHash = "sha256-1SpzOdxamiVl8G+KCD8JQfIFXWxHLjRPhz/+IlcOWhI=";

  # Patch layout to avoid Google Fonts fetch at build time (Nix sandbox has no network)
  postPatch = ''
    cat > app/layout.tsx <<'EOF'
    import "./globals.css"

    export default function RootLayout({ children }: { children: React.ReactNode }) {
    	return (
    		<html lang="en" suppressHydrationWarning>
    			<head>
    				<link rel="dns-prefetch" href="https://getbifrost.ai" />
    				<link rel="preconnect" href="https://getbifrost.ai" />
    			</head>
    			<body className="font-sans antialiased">{children}</body>
    		</html>
    	)
    }
    EOF
  '';

  npmBuildScript = "build-enterprise";
  env.NEXT_TELEMETRY_DISABLED = "1";
  env.NEXT_DISABLE_ESLINT = "1";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/ui"
    cp -R --no-preserve=mode,ownership,timestamps out/. "$out/ui/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Bifrost web UI";
    homepage = "https://github.com/maximhq/bifrost";
    license = licenses.asl20;
  };
}
