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
    if [[ "$attr_name" == "cudatoolkit" || "$attr_name" == "misskey" || "$attr_name" == "misskey-new" || "$attr_name" == "feishu" || "$attr_name" == "wechat" || "$attr_name" == "cider" || "$attr_name" == "cider3" || "$attr_name" == "koboldcpp" || "$attr_name" == "suyu" || "$attr_name" == "yuzu-early-access" ]]; then
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
    elif [[ "$attr_name" == "hydrogen-music" ]]; then
        (
            while true; do
                echo "[$(date)] Still building/pushing ${attr_name}..."
                sleep 60  # 每分钟输出一次状态
            done
        ) &
        KEEPALIVE_PID=$!
        if DRV_OUTPUT_PATH=$(nix build --no-link --print-out-paths --substituters "https://attic.hakutaku.org/nurpkgs" --trusted-public-keys "nurpkgs:gtUQ6um2j/MF+9nEDbsFa8S1dEct5YpaclN5/cHZFFE=" "${flake_ref}"); then
            attic push nurpkgs $DRV_OUTPUT_PATH
            kill $KEEPALIVE_PID
        else
            kill $KEEPALIVE_PID
            echo "    ERROR: Failed to build ${flake_ref}. Check Nix output above."
        fi

    else
        (
            while true; do
                echo "[$(date)] Still building/pushing ${attr_name}..."
                sleep 60  # 每分钟输出一次状态
            done
        ) &
        KEEPALIVE_PID=$!
        if DRV_OUTPUT_PATH=$(nix build --no-link --print-out-paths "${flake_ref}"); then
            attic push nurpkgs $DRV_OUTPUT_PATH
            kill $KEEPALIVE_PID
        else
            kill $KEEPALIVE_PID
            echo "    ERROR: Failed to build ${flake_ref}. Check Nix output above."
        fi
    fi
done
