{
  pkgs,
  buildVimPlugin,
  sources,
}:
{
  vim-edgemotion = pkgs.callPackage ./vim-edgemotion { inherit buildVimPlugin; };
  vim-pydocstring = pkgs.callPackage ./vim-pydocstring { inherit buildVimPlugin; };
  skkeleton = pkgs.callPackage ./skkeleton {
    inherit buildVimPlugin;
    source = sources.skkeleton;
  };
}
