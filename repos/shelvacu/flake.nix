{
  description = "Configs for shelvacu's nix things";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05-small";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable-small";

    disko = {
      url = "git+https://git.uninsane.org/shelvacu/disko.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko-unstable = {
      url = "git+https://git.uninsane.org/shelvacu/disko.git";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dns = {
      url = "github:nix-community/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    impermanence.url = "github:nix-community/impermanence";
    jovian-unstable = {
      # there is no stable jovian :cry:
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    most-winningest = {
      url = "github:captain-jean-luc/most-winningest";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-apple-silicon-unstable = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-unstable = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    padtype-unstable = {
      url = "git+https://git.uninsane.org/shelvacu/padtype.git";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sm64baserom.url = "git+https://git.uninsane.org/shelvacu/sm64baserom.git";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tf2-nix = {
      url = "gitlab:shelvacu-forks/tf2-nix/with-my-patches";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vacu-keys = {
      url = "git+https://git.uninsane.org/shelvacu/keys.nix.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-on-droid,
      ...
    }@inputs:
    let
      x86 = "x86_64-linux";
      arm = "aarch64-linux";
      lib = import "${nixpkgs}/lib";
      overlays = import ./overlays;
      vacuModules = import ./modules;
      mkPlainInner =
        pkgs:
        lib.evalModules {
          modules = [
            ./common
            { vacu.systemKind = "server"; }
          ];
          specialArgs = {
            inherit pkgs;
            inherit lib;
            inherit inputs;
            inherit (inputs) dns;
            inherit vacuModules;
            vaculib = import ./vaculib { inherit pkgs; };
            vacuModuleType = "plain";
          };
        };
      mkPlain =
        pkgs:
        let
          inner = mkPlainInner pkgs;
        in
        inner.config.vacu.withAsserts inner;
      mkPkgs =
        arg:
        let
          argAttrAll = if builtins.isString arg then { system = arg; } else arg;
          useUnstable = argAttrAll.useUnstable or false;
          whichpkgs = if useUnstable then inputs.nixpkgs-unstable else inputs.nixpkgs;
          argAttr = lib.removeAttrs argAttrAll [ "useUnstable" ];
          config = {
            allowUnfree = true;
            # the security warning might as well have said "its insecure maybe but there's nothing you can do about it"
            # presumably needed by nheko
            permittedInsecurePackages = [
              "olm-3.2.16"
              "fluffychat-linux-1.27.0"
            ];
          } // (argAttr.config or { });
        in
        import whichpkgs (
          argAttr // { inherit config; } // { overlays = (argAttr.overlays or [ ]) ++ overlays; }
        );
      pkgs = mkPkgs x86;
      defaultSuffixedInputNames = [
        "nixvim"
        "nixpkgs"
      ];
      defaultInputs = { inherit (inputs) self vacu-keys; };
      mkInputs =
        {
          unstable ? false,
          inp ? [ ],
        }:
        let
          suffix = if unstable then "-unstable" else "";
          inputNames = inp ++ defaultSuffixedInputNames;
          thisInputsA = builtins.listToAttrs (
            map (name: lib.nameValuePair name inputs.${name + suffix}) inputNames
          );
        in
        thisInputsA // defaultInputs;
      mkNixosConfig =
        {
          unstable ? false,
          module,
          system ? "x86_64-linux",
          inp ? [ ],
        }:
        let
          inputs = mkInputs { inherit unstable inp; };
          pkgs = mkPkgs {
            useUnstable = unstable;
            inherit system;
          };
        in
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit (inputs) dns;
            inherit vacuModules;
            vaculib = import ./vaculib { inherit pkgs; };
            vacuModuleType = "nixos";
          };
          inherit system;
          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./common
            module
          ];
        };
    in
    {
      debug.isoDeriv = (
        import "${inputs.nixpkgs}/nixos/release-small.nix" {
          nixpkgs = ({ revCount = 0; } // inputs.nixpkgs);
        }
      );

      lib = {
        inherit
          mkPlain
          mkPkgs
          mkInputs
          mkNixosConfig
          ;
      };

      nixosConfigurations = {
        triple-dezert = mkNixosConfig {
          module = ./triple-dezert;
          inp = [
            "most-winningest"
            "sops-nix"
          ];
        };
        compute-deck = mkNixosConfig {
          module = ./compute-deck;
          inp = [
            "jovian"
            "home-manager"
            "disko"
            "padtype"
          ];
          unstable = true;
        };
        liam = mkNixosConfig {
          module = ./liam;
          inp = [ "sops-nix" ];
        };
        lp0 = mkNixosConfig { module = ./lp0; };
        shel-installer-iso = mkNixosConfig { module = ./installer/iso.nix; };
        shel-installer-pxe = mkNixosConfig { module = ./installer/pxe.nix; };
        fw = mkNixosConfig {
          module = ./fw;
          inp = [
            "nixos-hardware"
            "sops-nix"
            "tf2-nix"
          ];
        };
        legtop = mkNixosConfig {
          module = ./legtop;
          inp = [ "nixos-hardware" ];
        };
        mmm = mkNixosConfig {
          module = ./mmm;
          inp = [ "nixos-apple-silicon" ];
          system = "aarch64-linux";
          unstable = true;
        };
        prophecy = mkNixosConfig {
          module = ./prophecy;
          system = "x86_64-linux";
          inp = [
            "impermanence"
            "sops-nix"
            "disko"
          ];
        };
      };

      nixOnDroidConfigurations.default =
        let
          pkgs = mkPkgs { system = arm; };
        in
        nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [
            ./common
            ./nix-on-droid
          ];
          extraSpecialArgs = {
            inputs = mkInputs { };
            inherit (inputs) dns;
            inherit vacuModules;
            vaculib = import ./vaculib { inherit pkgs; };
            vacuModuleType = "nix-on-droid";
          };
          inherit pkgs;
        };

      checks = nixpkgs.lib.genAttrs [ x86 ] (
        system:
        let
          pkgs = mkPkgs system;
          plain = mkPlain pkgs;
          commonTestModule = {
            hostPkgs = pkgs;
            _module.args.inputs = { inherit (inputs) self; };
            node.pkgs = pkgs;
            node.pkgsReadOnly = true;
            node.specialArgs = {
              inherit vacuModules;
              selfPackages = self.packages.${system};
              vaculib = import ./vaculib { inherit pkgs; };
              vacuModuleType = "nixos";
            };
          };
          mkTest =
            name:
            nixpkgs.lib.nixos.runTest {
              imports = [
                commonTestModule
                ./tests/${name}
                { node.specialArgs.inputs = self.nixosConfigurations.${name}._module.specialArgs.inputs; }
              ];
            };
          checksFromConfig = plain.config.vacu.checks;
        in
        assert !(checksFromConfig ? liam) && !(checksFromConfig ? trip);
        checksFromConfig
        // {
          liam = mkTest "liam";
          triple-dezert = mkTest "triple-dezert";
        }
      );

      buildList =
        let
          toplevelOf = name: self.nixosConfigurations.${name}.config.system.build.toplevel;
          deterministicCerts = import ./deterministic-certs.nix { nixpkgs = mkPkgs x86; };
          renamedAarchPackages = lib.mapAttrs' (
            name: value: lib.nameValuePair (name + "-aarch64") value
          ) self.packages.aarch64-linux;
          packages = self.packages.x86_64-linux // renamedAarchPackages;
          pxe-build = self.nixosConfigurations.shel-installer-pxe.config.system.build;
        in
        {
          fw = toplevelOf "fw";
          triple-dezert = toplevelOf "triple-dezert";
          compute-deck = toplevelOf "compute-deck";
          liam = toplevelOf "liam";
          lp0 = toplevelOf "lp0";
          legtop = toplevelOf "legtop";
          mmm = toplevelOf "mmm";
          shel-installer-iso = toplevelOf "shel-installer-iso";
          shel-installer-pxe = toplevelOf "shel-installer-pxe";
          prophecy = toplevelOf "prophecy";
          iso = self.nixosConfigurations.shel-installer-iso.config.system.build.isoImage;
          pxe-toplevel = toplevelOf "shel-installer-pxe";
          pxe-kernel = pxe-build.kernel;
          pxe-initrd = pxe-build.netbootRamdisk;
          check-triple-dezert = self.checks.x86_64-linux.triple-dezert.driver;
          check-liam = self.checks.x86_64-linux.liam.driver;
          liam-sieve = self.nixosConfigurations.liam.config.vacu.liam-sieve-script;

          nix-on-droid = self.nixOnDroidConfigurations.default.activationPackage;

          nod-bootstrap-x86_64 = inputs.nix-on-droid.packages.x86_64-linux.bootstrapZip-x86_64;
          nod-bootstrap-aarch64 = inputs.nix-on-droid.packages.x86_64-linux.bootstrapZip-aarch64;

          dc-priv = deterministicCerts.privKeyFile "test";
          dc-cert = deterministicCerts.selfSigned "test" { };

          inherit (inputs.nixos-apple-silicon-unstable.packages.aarch64-linux)
            m1n1
            uboot-asahi
            installer-bootstrap
            ;
          installer-bootstrap-cross =
            inputs.nixos-apple-silicon-unstable.packages.x86_64-linux.installer-bootstrap;
        }
        // packages;

      qb = self.buildList // {
        trip = self.buildList.triple-dezert;
        cd = self.buildList.compute-deck;
        lt = self.buildList.legtop;
        prop = self.buildList.prophecy;
        check-trip = self.buildList.check-triple-dezert;
        nod = self.buildList.nix-on-droid;
        ak = self.buildList.authorizedKeys;
        my-sops = self.buildList.wrappedSops;
      };

      brokenBuilds = [
        "sm64coopdx-aarch64"
        "installer-bootstrap"
      ];

      impureBuilds = [
        "nix-on-droid"
        "nod"
        "nod-bootstrap-x86_64"
        "nod-bootstrap-aarch64"
      ];

      archival = import ./archive.nix { inherit self pkgs lib; };
    }
    // (inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        nixpkgs-args = {
          inherit system;
          config.allowUnfree = true;
          overlays = [ inputs.sm64baserom.overlays.default ];
        };
        pkgs-unstable = mkPkgs (nixpkgs-args // { useUnstable = true; });
        pkgs-stable = mkPkgs (nixpkgs-args // { useUnstable = false; });
        vaculib = import ./vaculib { pkgs = pkgs-stable; };
        mkNixvim =
          { unstable, minimal }:
          let
            nixvim-input = if unstable then inputs.nixvim-unstable else inputs.nixvim;
          in
          nixvim-input.legacyPackages.${system}.makeNixvimWithModule {
            module = {
              imports = [ ./nixvim ];
              _module.args = { inherit pkgs-unstable; };
            };
            extraSpecialArgs = {
              inherit
                unstable
                inputs
                system
                minimal
                vaculib
                ;
            };
          };
        _plain = mkPlain pkgs-unstable;
        plain = _plain.config.vacu.withAsserts _plain;
        treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs-unstable ./treefmt.nix;
        formatter = treefmtEval.config.build.wrapper;
        vacuPackagePaths = import ./packages;
        vacuPackages = builtins.intersectAttrs vacuPackagePaths pkgs-stable;
      in
      {
        inherit formatter vaculib;
        apps.sops = {
          type = "app";
          program = lib.getExe self.packages.${system}.wrappedSops;
        };
        vacuconfig = plain.config;
        legacyPackages = {
          unstable = pkgs-unstable;
          stable = pkgs-stable;
        };
        packages = rec {
          archive = pkgs-stable.callPackage ./scripts/archive { };
          authorizedKeys = pkgs-stable.writeText "authorizedKeys" (
            lib.concatStringsSep "\n" (
              lib.mapAttrsToList (k: v: "${v} ${k}") plain.config.vacu.ssh.authorizedKeys
            )
          );
          dns = import ./scripts/dns {
            inherit pkgs lib inputs;
            inherit (plain) config;
          };
          inherit formatter;
          generated = pkgs-stable.linkFarm "generated" {
            nixpkgs = "${inputs.nixpkgs}";
            "liam-test/hints.py" = pkgs.writeText "hints.py" (
              import ./typesForTest.nix {
                name = "liam";
                inherit (pkgs-stable) lib;
                inherit self;
                inherit (inputs) nixpkgs;
              }
            );
            "dns/python-env" = builtins.dirOf (builtins.dirOf dns.interpreter);
            "mailtest/python-env" = builtins.dirOf (
              builtins.dirOf self.checks.x86_64-linux.liam.nodes.checker.vacu.mailtest.smtp.interpreter
            );
          };
          host-pxe-installer = pkgs.callPackage ./host-pxe-installer.nix {
            nixosInstaller = self.nixosConfigurations.shel-installer-pxe;
          };
          liam-sieve-script = self.nixosConfigurations.liam.config.vacu.liam-sieve-script;
          nixvim = mkNixvim {
            unstable = false;
            minimal = false;
          };
          nixvim-unstable = mkNixvim {
            unstable = true;
            minimal = false;
          };
          nixvim-minimal = mkNixvim {
            unstable = false;
            minimal = true;
          };
          nixvim-unstable-minimal = mkNixvim {
            unstable = true;
            minimal = true;
          };
          sopsConfig = plain.config.vacu.sopsConfigFile;
          sourceTree = plain.config.vacu.sourceTree;
          units = plain.config.vacu.units.finalPackage;
          vnopnCA = pkgs-stable.writeText "vnopnCA.cert" plain.config.vacu.vnopnCA;
          wrappedSops = plain.config.vacu.wrappedSops;
        } // vacuPackages;
      }
    ));
}
