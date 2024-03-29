# receives: list of modules to import, type of item looking for in modules
# returns: paths of the modules it found
items:
component:
let
  inherit (builtins) split toString pathExists toPath;

  filter = import <dotfiles/lib/filter.nix>;
  tail = import <dotfiles/lib/tail.nix>;
  modulePath = <dotfiles/modules>;
  getModuleName = item: tail (split "/" (toString item));
  suffixifyItem = item:
    let
      suffix = "/" + item + "/" + component + ".nix";
    in
    <dotfiles/modules> + suffix;
  suffixedItems = map suffixifyItem (map getModuleName items);
  filteredItems = filter pathExists suffixedItems;
in
map toPath filteredItems
