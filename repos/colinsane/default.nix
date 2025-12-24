# this is the entry point for most `nix` commands run against this repo.
# it's written as a chain loader:
#
# 1. copy everything* under this directory tree into the nix store.
# 2. exec into `/nix/store/.../default.nix`.
#
# the point of this is to allow mutating of this repo even while outstanding nix operations
# are in flight, without affecting those in-flight operations.
#
# * certain ephemeral files like `result` links aren't copied, as they aren't used but incur huge copying costs.
{ ... }@args:
let
  sane-nix-files = import ./pkgs/by-name/sane-nix-files/package.nix { };
in
  import "${sane-nix-files}/impure.nix" args
