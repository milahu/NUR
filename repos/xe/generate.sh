#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-github nix-prefetch-git jq

# github repos

nix-prefetch-github golang tools > "./pkgs/gopls/source.json"
nix-prefetch-github luakit luakit > "./pkgs/luakit/source.json"
nix-prefetch-github Shopify comma > "./pkgs/comma/source.json"
nix-prefetch-github pigpigyyy MoonPlus > "./pkgs/MoonPlus/source.json"
nix-prefetch-github amir sctd > "./pkgs/sctd/source.json"
nix-prefetch-github jroimartin sw > "./pkgs/sw/source.json"
nix-prefetch-github cls libutf > "./pkgs/libutf/source.json"
nix-prefetch-github lunasorcery pridecat > "./pkgs/pridecat/source.json"
nix-prefetch-github wezm steno-lookup > "./pkgs/steno-lookup/source.json"

# git repos
nix-prefetch-git https://tulpa.dev/cadey/dwm.git | jq 'del(.date)' | jq 'del(.path)' > "./pkgs/dwm/source.json"
nix-prefetch-git https://tulpa.dev/lua/dnd_dice.git | jq 'del(.date)' | jq 'del(.path)' > "./pkgs/lua/dnd_dice/source.json"
nix-prefetch-git https://git.sr.ht/~rabbits/orca | jq 'del(.date)' | jq 'del(.path)' > "./pkgs/orca/source.json"
nix-prefetch-git git://git.suckless.org/lchat | jq 'del(.date)' | jq 'del(.path)' > "./pkgs/lchat/source.json"
