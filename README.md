# NUR

[![Build Status](https://travis-ci.com/nix-community/NUR.svg?branch=master)](https://travis-ci.com/nix-community/NUR)

The Nix User Repository (NUR) is community-driven meta repository for nix packages
It provides access to user repositories that contain package descriptions (nix
expressions) and allow to install those by referencing them via attributes.
In contrast to [nixpkgs](https://github.com/NixOS/nixpkgs/) packages are build
from source and are not reviewed by Nixpkgs member.
The NUR was created to share new packages from the community in a faster and
more decentralized way.
NUR automatically check its list of repositories and perform evaluation checks
before it propagated the update.

## How to use

First include NUR in your `packageOverrides`:

To make NUR accessible for your login user, add the following to `~/.config/nixpkgs/config.nix`:

```nix
{
  packageOverrides = pkgs: {
    nur = pkgs.callPackage (import (builtins.fetchGit {
      url = "https://github.com/nix-community/NUR";
    })) {};
  };
}
```

For NixOS add the following to your `/etc/nixos/configuration.nix`:

```nix
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = pkgs.callPackage (import (builtins.fetchGit {
      url = "https://github.com/nix-community/NUR";
    })) {};
  };
}
```

Then packages can be used or installed from the nur namespace.

```console
$ nix-shell -p nur.repos.mic92.inxi
nix-shell> inxi
CPU: Dual Core Intel Core i7-5600U (-MT MCP-) speed/min/max: 3061/500/3200 MHz Kernel: 4.14.51 x86_64
Up: 20h 55m Mem: 12628.4/15926.8 MiB (79.3%) HDD: 465.76 GiB (39.3% used) Procs: 409
Shell: bash 4.4.23 inxi: 3.0.10
```

or

```console
$ nix-env -iA nur.repos.mic92.inxi
```

or

```console
# configuration.nix
environment.systemPackages = [
  nur.repos.mic92.inxi
];
```

Each contributor can register their repository under a name and is responsible
for its content.
NUR does not check repository for malicious content on a regular base and it is
recommend to check expression before installing them.


## How to add your own repository.

First create a repository that contains a `default.nix` in its top-level directory.

DO NOT import packages for example `with import <nixpkgs> {};`.
Instead take all dependency you want to import from nixpkgs by function arguments.
Each repository should return a set of nix derivations:

```nix
{ callPackage }:
{
  inxi = callPackage ./inxi {};
}
```

In this example `inxi` would be a directory containing a `default.nix`:

```nix
{ stdenv, fetchFromGitHub
, makeWrapper, perl
, dmidecode, file, hddtemp, nettools, iproute, lm_sensors, usbutils, kmod, xlibs
}:

let
  path = [
    dmidecode file hddtemp nettools iproute lm_sensors usbutils kmod
    xlibs.xdpyinfo xlibs.xprop xlibs.xrandr
  ];
in stdenv.mkDerivation rec {
  name = "inxi-${version}";
  version = "3.0.14-1";

  src = fetchFromGitHub {
    owner = "smxi";
    repo = "inxi";
    rev = version;
    sha256 = "0wyv8cqwy7jlv2r3j7w8ri73iywawnaihww39vlpnpjjcz1b37hw";
  };

  installPhase = ''
    install -D -m755 inxi $out/bin/inxi
    install -D inxi.1 $out/man/man1/inxi.1
    wrapProgram $out/bin/inxi \
      --prefix PATH : ${ stdenv.lib.makeBinPath path }
  '';

  buildInputs = [ perl ];
  nativeBuildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "System information tool";
    homepage = https://github.com/smxi/inxi;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
```

You can use `nix-shell` or `nix-build` to build your packages:

```console
$ nix-shell -E 'with import <nixpkgs>{}; (callPackage ./default.nix {}).inxi'
nix-shell> inxi
nix-shell> find $buildInputs
```

```console
$ nix-build -E 'with import <nixpkgs>{}; (callPackage ./default.nix {})'
```

Add your own repository to in the `repos.json` of NUR:

```console
$ git clone https://github.com/nix-community/NUR
# open and modify repos.json in an editor
```

```json
{
    "repos": {
        "mic92": {
            "url": "https://github.com/Mic92/nur-packages"
        },
        "<fill-your-repo-name>": {
            "url": "https://github.com/<your-user>/<your-repo>"
        }
    }
}
```

At moment each URL must point to a git repository. By running `nur/update.py`
the corresponding `repos.json.lock` is updated and the result tested. This will
perform also an evaluation check, which must be passed. Commit the changed
`repos.json` but NOT `repos.json.lock` and open a pull request towards
https://github.com/nix-community/NUR.
