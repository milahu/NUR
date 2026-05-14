BEGIN { state = 0 }

# Look for "packages = forAllSystems"
state == 0 && /^[[:space:]]*packages = forAllSystems/ { state = 1; next }

# Inside packages, find the inner rec (8-space indent)
state == 1 && /^[[:space:]]{8}rec$/ { state = 2; next }

# Then the { on the next line
state == 2 && /^[[:space:]]{8}\{/   { state = 3; brace_depth = 1; next }

state != 3 { next }

# ---- We are inside the packages rec block ----

{
  n_open  = gsub(/\{/, "&")
  n_close = gsub(/\}/, "&")
  brace_depth += n_open - n_close
  if (brace_depth <= 0) exit
}

# Skip internal bindings - these are parameters in default.nix
/^[[:space:]]*pkgs = import nixpkgs/              { next }
/^[[:space:]]*pkgs-stable = import nixpkgs-stable/ { next }
/^[[:space:]]*pkgs-yuzu = import nixpkgs-yuzu/     { next }
/^[[:space:]]*pkgs-chaotic = inputs\.chaotic/      { next }

# Skip pkgs-go = import nixpkgs { ... } (multi-line)
/^[[:space:]]*pkgs-go = import nixpkgs/ {
  in_skip = 1; skip_depth = 1; next
}
# Skip bifrost packages (depend on pkgs-go via go-overlay, not NUR-friendly)
/^[[:space:]]*# Go packages requiring newer Go toolchain/ { next }
/^[[:space:]]*bifrost(-src|-ui)?[[:space:]]*=[[:space:]]*pkgs-go/ {
  in_skip = 1; skip_depth = 1; next
}
# Skip rust packages whose cargoLock.lockFile reads from sources.<x>.src/Cargo.lock
# (IFD on a FOD src; NUR's restricted eval can't realise the src during evaluation)
/^[[:space:]]*(aichat|fww-checkin-rs|ncmdump-rs|rescrobbled)[[:space:]]*=[[:space:]]*pkgs\.callPackage/ { next }
# Skip Garnix cache helpers (not useful to NUR consumers)
/^[[:space:]]*# Garnix generate cache/ { next }
/^[[:space:]]*mongodb[[:space:]]*=[[:space:]]*pkgs-stable\.mongodb/ { next }
in_skip {
  n_open  = gsub(/\{/, "&")
  n_close = gsub(/\}/, "&")
  skip_depth += n_open - n_close
  if (skip_depth <= 0) { in_skip = 0 }
  next
}

# ---- Transform to default.nix format ----

# Strip leading 10 spaces -> 2 spaces
{ sub(/^[[:space:]]{10}/, "  ") }

# Handle pkgs-chaotic references: wrap with null guard
/pkgs-chaotic\./ {
  match($0, /^([[:space:]]*)([a-zA-Z_][a-zA-Z0-9_-]*)[[:space:]]*=[[:space:]]*(.+)/, m)
  if (m[1] != "" && m[2] != "" && m[3] != "") {
    # strip comment and trailing semicolons from value
    val = m[3]
    sub(/[[:space:]]*# for cache[[:space:]]*$/, "", val)
    sub(/[[:space:]]*;[[:space:]]*$/, "", val)
    print m[1] m[2] " ="
    print m[1] "  if pkgs-chaotic != null then"
    print m[1] "    " val
    print m[1] "  else null;"
    next
  }
}

# Remove trailing comment "# for cache"
{ sub(/[[:space:]]*# for cache[[:space:]]*$/, "") }

{ print }
