mapfile -t PKG_ATTR_NAMES < <(nix flake show --json . 2>/dev/null | jq -r --arg cur_sys "x86_64-linux" '(.packages[$cur_sys] // {}) | keys[]')
echo "INFO: Found ${#PKG_ATTR_NAMES[@]} package attributes to build:"
printf "  - %s\n" "${PKG_ATTR_NAMES[@]}"
for attr_name in "${PKG_ATTR_NAMES[@]}"; do
    flake_ref=".#${attr_name}"
    echo "--> Building ${flake_ref}..."
    # nix build:
    #   --no-link: We don't need the ./result symlink.
    #   --print-out-paths: Prints the actual store path(s) to stdout on success.
    #   If the build fails, nix build exits non-zero and prints errors to stderr.
    #   The 'if' condition checks the exit status of nix build.
    if DRV_OUTPUT_PATH=$(nix build --no-link --print-out-paths "${flake_ref}"); then
        attic push nurpkgs $DRV_OUTPUT_PATH
    else
        echo "    ERROR: Failed to build ${flake_ref}. Check Nix output above."
    fi
done
