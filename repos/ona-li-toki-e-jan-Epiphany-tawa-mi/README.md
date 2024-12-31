# epitaphpkgs

My personal Nix package repository, currently consisting solely of software I
have written myself.

Package index:

#### ahd

- Description: Hexdump utility.
- Homepage: [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/AHD](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/AHD)
- License: GPL-3.0-or-later.

#### bitmasher

- Description: A fast-paced text adventure game inside a ransomware-infected computer.
- Homepage: [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/BitMasher](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/BitMasher)
- License: GPL-3.0-or-later.

#### cobol-dvd-thingy

- Description: Terminal screensaver similar to that of DVD players.
- Homepage: [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/COBOL-DVD-Thingy](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/COBOL-DVD-Thingy)
- License: GPL-3.0-or-later.

#### cowsaypl

- Description: Cowsay in GNU APL.
- Homepage: [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/cowsAyPL](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/cowsAyPL)
- License: GPL-3.0-or-later.

#### love-you-mom

- Description: Tells your mom (or dad) that you love them.
- Homepage: [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/love-you-mom](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/love-you-mom)
- License: GPL-3.0-or-later.

#### netcatchat

- Description: A simple command-line chat server and client using netcat.
- Homepage: [https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/netcatchat](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/netcatchat)
- License: MIT.

## Usage Examples

### Run Package in Temporary Environment with `nix run`

```sh
$ echo -n 'This is a test' | nix run github:ona-li-toki-e-jan-Epiphany-tawa-mi/epitaphpkgs#ahd
<nix output...>
0000000: 54 68 69 73 20 69 73 20 61 20 74 65 73 74       |This is a test|
```

### Flake Input

```nix
{
  inputs = {
    nixpkgs.url = <some version of nixpkgs>;

    epitaphpkgs = {
      url = "github:ona-li-toki-e-jan-Epiphany-tawa-mi/epitaphpkgs";
      # Makes epitaphpkgs use the nixpkgs version specified in the flake. If you
      # don't put this, it will use nixpkgs-unstable.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

### In NixOS via Flake

flake.nix:

```nix
{
  inputs = {
    nixpkgs.url = <some version of nixpkgs>;

    epitaphpkgs = {
      url = "github:ona-li-toki-e-jan-Epiphany-tawa-mi/epitaphpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, epitaphpkgs, ... } @ inputs: {
    nixosConfigurations.exampleMachine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # The default module from epitaphpkgs includes an overlay that adds the
        # packages under pkgs.epitaphpkgs.
        epitaphpkgs.nixosModules.default

        ./hosts/exampleMachine/configuration.nix
      ];
    };
  };
}
```

./hosts/exampleMachine/configuration.nix:

```nix
{ pkgs
, ...
}:

{
  # Here, we include the ahd package from the overlay we previously added in
  # flake.nix and add it to the environment
  environment.systemPackages = with pkgs.epitaphpkgs; [ ahd ];
}
```
