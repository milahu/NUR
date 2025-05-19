mapfile -t PKG_ATTR_NAMES < <(nix flake show --json . 2>/dev/null | jq -r --arg cur_sys "x86_64-linux" '(.packages[$cur_sys] // {}) | keys[]')
echo "INFO: Found ${#PKG_ATTR_NAMES[@]} package attributes to build:"
printf "  - %s\n" "${PKG_ATTR_NAMES[@]}"
for attr_name in "${PKG_ATTR_NAMES[@]}"; do
    flake_ref=".#${attr_name}"
    echo "--> Building ${flake_ref}..."
    if [[ "$attr_name" == "suyu" || "$attr_name" == "yuzu-early-access" ]]; then
    	(
            while true; do
                echo "[$(date)] Still building/pushing ${attr_name}..."
                sleep 60  # 每分钟输出一次状态
            done
        ) &
        KEEPALIVE_PID=$!
        if DRV_OUTPUT_PATH=$(nix build --no-link --print-out-paths --substituters "https://cache.nixos.org" "${flake_ref}"); then
            attic push nurpkgs $DRV_OUTPUT_PATH
            kill $KEEPALIVE_PID
        else
            kill $KEEPALIVE_PID
            echo "    ERROR: Failed to build ${flake_ref}. Check Nix output above."
        fi
    else
        continue
    fi
done
