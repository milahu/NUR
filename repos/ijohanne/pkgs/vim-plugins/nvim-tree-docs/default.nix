{ pkgs, sources }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  name = "nvim-tree-docs-master";
  version = "master";
  pname = "nvim-tree-docs";
  src = sources.nvim-tree-docs;
  doCheck = false;
}
