# XXX: this is in the bootstrap path;
# this means it has to be evaluatable using only builtins,
# though i'm free to include optional functionality (e.g. update scripts) so long as i gate it behind availability checks.
#
# branch workflow:
# - daily:
#   - nixos-unstable cut from master after enough packages have been built in caches.
# - every 6 hours:
#   - master auto-merged into staging and staging-next
#   - staging-next auto-merged into staging.
# - manually, approximately once per month:
#   - staging-next is cut from staging.
#   - staging-next merged into master.
#
# which branch to source from?
# - nixos-unstable: for everyday development; it provides good caching
# - master: temporarily if i'm otherwise cherry-picking lots of already-applied patches
# - staging-next: if testing stuff that's been PR'd into staging, i.e. base library updates.
# - staging: maybe if no staging-next -> master PR has been cut yet?
{ variant ? "master"
, doPatch ? true
, localSystem ? builtins.currentSystem  #< not available in pure mode
, system ? localSystem
#VVV these may or may not be available when called VVV
, fetchzip ? builtins.fetchTarball
, nix-update-script ? null
}:
let
  lock = {
    master.rev = "61d815a20bdb9fd827c379de088a345aa8adfc60";
    master.sha256 = "sha256-CyhuwWACUApIW7tq38FjddWdPhLHQXCXhhd/ivu4FeE=";
    staging.rev = "61d815a20bdb9fd827c379de088a345aa8adfc60";
    staging.sha256 = "sha256-CyhuwWACUApIW7tq38FjddWdPhLHQXCXhhd/ivu4FeE=";
    staging-next.rev = "61d815a20bdb9fd827c379de088a345aa8adfc60";
    staging-next.sha256 = "sha256-CyhuwWACUApIW7tq38FjddWdPhLHQXCXhhd/ivu4FeE=";
  };
  lock' = lock."${variant}";
  unpatchedSrc = fetchzip {
    url = "https://github.com/NixOS/nixpkgs/archive/${lock'.rev}.tar.gz";
    inherit (lock') sha256;
  };
  commonNixpkgsArgs = {
    inherit localSystem;
    # reset impurities
    config = {};
    overlays = [];
  };
  unpatchedNixpkgs = import unpatchedSrc commonNixpkgsArgs;

  patchedSrc = unpatchedNixpkgs.applyPatches {
    name = "nixpkgs-patched-uninsane";
    # version = ...
    src = unpatchedSrc;
    patches = unpatchedNixpkgs.callPackage ./list.nix { };
    # skip applied patches
    prePatch = ''
      realpatch=$(command -v patch)
      patch() {
         OUT=$($realpatch "$@") || echo "$OUT" | grep "Skipping patch" -q
      }
    '';
  };

  src = if doPatch then patchedSrc else { outPath = unpatchedSrc; };
  args = commonNixpkgsArgs // {
    config = {
      allowUnfree = true;  # NIXPKGS_ALLOW_UNFREE=1
      allowBroken = true;  # NIXPKGS_ALLOW_BROKEN=1
      permittedInsecurePackages = [
        "jitsi-meet-1.0.8043"  #< XXX(2024-08-17): used by element-web, and probably in a safe way. see: <https://github.com/NixOS/nixpkgs/pull/334638>
      ];
    };
  } // (if (system != localSystem) then {
    # XXX(2023/12/11): cache.nixos.org uses `system = ...` instead of `hostPlatform.system`, and that choice impacts the closure of every package.
    # so avoid specifying hostPlatform.system on non-cross builds, so i can use upstream caches.
    crossSystem = system;
  } else {});

  nixpkgs = import "${src}" args;
in
  # N.B.: this is crafted to allow `nixpkgs.FOO` from other nix code
  # AND `nix-build -A nixpkgs`
  if src ? overrideAttrs then
    src.overrideAttrs (base: {
      # attributes needed for update scripts
      pname = "nixpkgs";
      version = "0-unstable-2024-08-25";
      passthru = (base.passthru or {}) // nixpkgs // {
        src = unpatchedSrc // {
          inherit (lock') rev;
        };
        updateScript = nix-update-script {
          extraArgs = [ "--version" "branch" ];
        };
      };
    })
  else
    nixpkgs
