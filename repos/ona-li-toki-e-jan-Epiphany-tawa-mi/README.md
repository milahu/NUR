# epitaphpkgs

My personal Nix package repository, currently consisting solely of software I
have written myself.

Package index:

#### ahd

- Description: Hexdump utility.
- Homepage: [https://paltepuk.xyz/cgit/AHD.git/about](https://paltepuk.xyz/cgit/AHD.git/about)
- License: GPL-3.0-or-later.

#### bitmasher

- Description: A fast-paced text adventure game inside a ransomware-infected computer.
- Homepage: [https://paltepuk.xyz/cgit/BitMasher.git/about](https://paltepuk.xyz/cgit/BitMasher.git/about)
- License: GPL-3.0-or-later.

#### cobol-dvd-thingy

- Description: Terminal screensaver similar to that of DVD players.
- Homepage: [https://paltepuk.xyz/cgit/COBOL-DVD-Thingy.git/about](https://paltepuk.xyz/cgit/COBOL-DVD-Thingy.git/about)
- License: GPL-3.0-or-later.

#### cowsaypl

- Description: Cowsay in GNU APL.
- Homepage: [https://paltepuk.xyz/cgit/cowsAyPL.git/about](https://paltepuk.xyz/cgit/cowsAyPL.git/about)
- License: GPL-3.0-or-later.

#### love-you-mom

- Description: Tells your mom (or dad) that you love them.
- Homepage: [https://paltepuk.xyz/cgit/love-you-mom.git/about](https://paltepuk.xyz/cgit/love-you-mom.git/about)
- License: GPL-3.0-or-later.

#### netcatchat

- Description: A simple command-line chat server and client using netcat.
- Homepage: [https://paltepuk.xyz/cgit/netcatchat.git/about](https://paltepuk.xyz/cgit/netcatchat.git/about)
- License: GPL-3.0-or-later.

#### play-music

- Description: A simple command-line music player.
- Homepage: [https://paltepuk.xyz/cgit/play-music.git/about](https://paltepuk.xyz/cgit/play-music.git/about)
- License: GPL-3.0-or-later.

## Usage Examples

### Run Package in Temporary Environment with `nix run`

```sh
$ echo -n 'This is a test' | nix run git+https://paltepuk.xyz/cgit/epitaphpkgs.git#ahd
<nix output...>
0000000: 54 68 69 73 20 69 73 20 61 20 74 65 73 74       |This is a test|
```

### Flake Input

```nix
{
  inputs = {
    nixpkgs.url = <some version of nixpkgs>;

    epitaphpkgs = {
      url = "git+https://paltepuk.xyz/cgit/epitaphpkgs.git";
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
      url = "git+https://paltepuk.xyz/cgit/epitaphpkgs.git";
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
