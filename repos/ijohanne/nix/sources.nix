# Resolve flake inputs from flake.lock for non-flake usage (e.g. NUR evaluator, ci.nix).
# Only resolves non-flake inputs (flake = false); real flake inputs are handled separately.
# In flake context, sources are passed from flake inputs directly.
let
  lock = builtins.fromJSON (builtins.readFile ../flake.lock);
  root = lock.nodes.${lock.root};

  fetchInput = name:
    let
      inputRef = root.inputs.${name};
      nodeName = if builtins.isList inputRef then builtins.head inputRef else inputRef;
      node = lock.nodes.${nodeName};
      locked = node.locked;
    in
    builtins.fetchTarball {
      url = "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
      sha256 = locked.narHash;
    };

  isNonFlakeInput = name:
    let
      inputRef = root.inputs.${name};
      nodeName = if builtins.isList inputRef then builtins.head inputRef else inputRef;
      node = lock.nodes.${nodeName};
    in
    node ? flake && node.flake == false;

  sourceNames = builtins.filter isNonFlakeInput
    (builtins.attrNames (builtins.removeAttrs root.inputs [ "nixpkgs" ]));
in
builtins.listToAttrs (map (name: { inherit name; value = fetchInput name; }) sourceNames)
