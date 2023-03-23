# NOTE: This file is autogenerated by update.rb, do not edit manually!
{ stdenv, lib, callPackage, fetchurl, file, glibc, expat, gmp5, libmpc, ncurses6 }:

let
  mpfr_3 = callPackage ./mpfr-3.nix {};

  fetchBootlinToolchain = arch: name: sha256: stdenv.mkDerivation {
    name = "bootlin-toolchain-${name}";

    src = fetchurl {
      url = "https://toolchains.bootlin.com/downloads/releases/toolchains/${arch}/tarballs/${name}.tar.bz2";
      inherit sha256;
    };

    nativeBuildInputs = [ file ];
    rpath = lib.makeLibraryPath [ glibc stdenv.cc.cc expat gmp5 libmpc mpfr_3 ncurses6 ];

    unpackPhase = ''
      mkdir -p $out
      tar --strip-components=1 -C $out -xf $src
    '';

    installPhase = ''
      $out/relocate-sdk.sh

      # These fail to relocate and are easily provided by Nix anyway.
      # Only ARC toolchains have them anyway.
      rm -rf $out/bin/flex $out/bin/flex++ || true
      rm -rf $out/bin/bison $out/share/bison || true

      # Remove other unnecessary junk.
      rm -rf $out/etc $out/relocate-sdk.sh $out/README.txt $out/share/doc $out/share/info

      for f in $(find $out/bin/ $out/*/bin/ $out/libexec -type f -executable); do
        # Some things in libexec are .so files or shell scripts, skip over those.
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f || continue
        patchelf --set-rpath "$rpath" $f
      done
    '';

    dontStrip = true;
  };
in {
    aarch64 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "aarch64" "aarch64--glibc--bleeding-edge-2018.07-3" "f1789f9de5dbea79490da76b71ca90fde187ecc0872cb0c74c33b328d557f9b0";
            stable = fetchBootlinToolchain "aarch64" "aarch64--glibc--stable-2018.02-2" "8384146f3e79591f41b32d553fcb518c05667ddcbabe01feb1da4b7350b8f3ff";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "aarch64" "aarch64--musl--bleeding-edge-2018.07-3" "a5dff4072a73016093d8d22845e4650411dde7259c990166723c8c927b4776cc";
            stable = fetchBootlinToolchain "aarch64" "aarch64--musl--stable-2018.02-2" "8847a6d00270ddf6a669564f8b0d05ad4650f7ebfb2ac2a2d78445f194ec277e";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "aarch64" "aarch64--uclibc--bleeding-edge-2018.07-3" "f06ebc07d372e1734f5cd7ff525307a624e420f117904c29707a3fbaa6d8de2f";
            stable = fetchBootlinToolchain "aarch64" "aarch64--uclibc--stable-2018.02-2" "b4b8b396d6faf4a6151af144a90252105a7bd40c15e5e1d6e3f071d75fbcf78f";
        };
    };
    aarch64be = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "aarch64be" "aarch64be--glibc--bleeding-edge-2018.07-3" "0309b21d9570b4b0e966806e6503e76c83c08ecc7f2091a0290d1a7344fa014e";
            stable = fetchBootlinToolchain "aarch64be" "aarch64be--glibc--stable-2018.02-2" "404aad5e8b1c890b684fa2efb8e36300b425b0037e2cf4f9038e97191467f98f";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "aarch64be" "aarch64be--uclibc--bleeding-edge-2018.07-3" "ff58a252419359a9dd137233e825cf3312b27699e8c08469ee01f3884d582f04";
            stable = fetchBootlinToolchain "aarch64be" "aarch64be--uclibc--stable-2018.02-2" "a34fc80f1c93b9b74aa41bd3ccf897d3eab55c6e9163133679418788256ef797";
        };
    };
    arcle-750d = {
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "arcle-750d" "arcle-750d--uclibc--bleeding-edge-2018.07-3" "bf3ffb9844533ce69751081eff48f3a6d885aab551924a7110739d1b0e041316";
            stable = fetchBootlinToolchain "arcle-750d" "arcle-750d--uclibc--stable-2018.02-2" "c993dc9508a4dcbf66ebd644b30dba1f8cd5d667cad7345bfbde2533f142cfaa";
        };
    };
    arcle-hs38 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "arcle-hs38" "arcle-hs38--glibc--bleeding-edge-2018.07-3" "4fd6406e7181347347d007571e08c08f724d2d7680884bdbe35adec46e64006e";
            stable = fetchBootlinToolchain "arcle-hs38" "arcle-hs38--glibc--stable-2018.02-2" "512ab489f03da851053d47661ea95714ab1520296ece0715bf506457cad8375d";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "arcle-hs38" "arcle-hs38--uclibc--bleeding-edge-2018.07-3" "06cc15d80835331ccbecbe46fdf64cff3f3afd38c05aa279fdcbfe14f15928c9";
            stable = fetchBootlinToolchain "arcle-hs38" "arcle-hs38--uclibc--stable-2018.02-2" "da39e81832d9a04ba00e9dc1d85470c8f25fe9c23023685dec82b813cfbd293b";
        };
    };
    armebv7-eabihf = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "armebv7-eabihf" "armebv7-eabihf--glibc--bleeding-edge-2018.07-3" "2a7416e99c91aaf2e82136bc47713e098233d322d4d79bee4b0ef69c55681def";
            stable = fetchBootlinToolchain "armebv7-eabihf" "armebv7-eabihf--glibc--stable-2018.02-2" "3c322235c518ebc6e2ece1b325e89b96cfe6299540932cd5381f627d2c2a6b85";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "armebv7-eabihf" "armebv7-eabihf--musl--bleeding-edge-2018.07-3" "a3a409a49699854e3677f102215b1a39d48e43d87a2b173d5f847dee6d3f82c1";
            stable = fetchBootlinToolchain "armebv7-eabihf" "armebv7-eabihf--musl--stable-2018.02-2" "55ce90e44aae628e7a2697a10c33cee1efa758f0eb80516c71bff592444dc36a";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "armebv7-eabihf" "armebv7-eabihf--uclibc--bleeding-edge-2018.07-3" "bda51420bf844d29993d69df9f02082e36f8dad313a1e6c86c6772718d69418a";
            stable = fetchBootlinToolchain "armebv7-eabihf" "armebv7-eabihf--uclibc--stable-2018.02-2" "cd50f4e63501f3f497be5dba491455b90b5222f00e9ee325daab817f51525904";
        };
    };
    armv5-eabi = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "armv5-eabi" "armv5-eabi--glibc--bleeding-edge-2018.07-3" "a3f874534c8f51083949a0259c1f320b9bd4b08ec7a1679b40dcec0f32adc3b1";
            stable = fetchBootlinToolchain "armv5-eabi" "armv5-eabi--glibc--stable-2018.02-2" "51740e636ff46ca806621ba64ad6f384b4e2878f5fed2019bdbf5e279165a372";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "armv5-eabi" "armv5-eabi--musl--bleeding-edge-2018.07-3" "d2b328a7a90f2c8ee03212adf1888e09e5b549bfb7c01843043d73a368320531";
            stable = fetchBootlinToolchain "armv5-eabi" "armv5-eabi--musl--stable-2018.02-2" "32ffe237cd0194e98e78eb9e601eca329e0fed16c9cb925cb1cc452c8b54ef4f";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "armv5-eabi" "armv5-eabi--uclibc--bleeding-edge-2018.07-3" "0d93a1189525ef4331c635d9d1f78e8d9c0a51eabcd63801d9c00d908ef9f291";
            stable = fetchBootlinToolchain "armv5-eabi" "armv5-eabi--uclibc--stable-2018.02-2" "21f77d9727aa600851a59d5011d7f1f1c42ad49e85e8c78923dc179d8eb043e4";
        };
    };
    armv6-eabihf = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "armv6-eabihf" "armv6-eabihf--glibc--bleeding-edge-2018.07-3" "4cbd5f282ad6a20058d406812f5ce533bd9769f94e8b594e2f45b7525a03ce91";
            stable = fetchBootlinToolchain "armv6-eabihf" "armv6-eabihf--glibc--stable-2018.02-2" "59ca559a0a7a446c2826b52a7e96b0d14133f2096a9f7a9af5cfb4ace0f33470";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "armv6-eabihf" "armv6-eabihf--musl--bleeding-edge-2018.07-3" "593527b8a1492475879c9516faefc630eee876902cd4f405660e1d96dff0822a";
            stable = fetchBootlinToolchain "armv6-eabihf" "armv6-eabihf--musl--stable-2018.02-2" "f18d2a5c58afe38b935ce73dcd3dbbd64460d4cfc4667d31340866acc198a125";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "armv6-eabihf" "armv6-eabihf--uclibc--bleeding-edge-2018.07-3" "2a6f20094fc9327b5a9a0a85d74d211e29e597a384e9f17ba5cf51c76858fdf4";
            stable = fetchBootlinToolchain "armv6-eabihf" "armv6-eabihf--uclibc--stable-2018.02-2" "b2117cf9ac93b95ad9df0ddc4eb3e89105599275db3368ab61c6c7519906eed7";
        };
    };
    armv7-eabihf = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "armv7-eabihf" "armv7-eabihf--glibc--bleeding-edge-2018.07-3" "9c45a1c9cf5c70ed26348a7d2420733dbb7eb9eaae0b87ae2d6017a7f188f6ab";
            stable = fetchBootlinToolchain "armv7-eabihf" "armv7-eabihf--glibc--stable-2018.02-2" "32723810be37418bb9e5a7da5bec96719bf0c2eb2b919f85dfd5a02c449a451f";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "armv7-eabihf" "armv7-eabihf--musl--bleeding-edge-2018.07-3" "e00b236d8058ab473b00bbced6c34fea614ba344c82145350069c94ed9dc5e4c";
            stable = fetchBootlinToolchain "armv7-eabihf" "armv7-eabihf--musl--stable-2018.02-2" "fcf96bf164c103285cb2cbe4fa25f708e8adb2cf39b576717c4d42955a744060";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "armv7-eabihf" "armv7-eabihf--uclibc--bleeding-edge-2018.07-3" "93c26da3d0cce0d94945bd8b3b234a8996a5959d1e1fb9aaf40eeff9877f7e06";
            stable = fetchBootlinToolchain "armv7-eabihf" "armv7-eabihf--uclibc--stable-2018.02-2" "0aa858a62e6574e4948854bcfd9165b6a58436f2801c08599afad45cc30ac682";
        };
    };
    armv7m = {
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "armv7m" "armv7m--uclibc--bleeding-edge-2018.07-3" "0125b25895a59c0e67f0336ff8eea8db5cb8b1bc2d6ec2f3261f91f6013818ba";
            stable = fetchBootlinToolchain "armv7m" "armv7m--uclibc--stable-2018.02-2" "5816d792e96501f17fce4184a0b736ad214484a853b85490fa23212559c739f8";
        };
    };
    bfin = {
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "bfin" "bfin--uclibc--bleeding-edge-2018.02-1" "1d0aa5e55f3179d3f3ae3ec06e7769ebca9154d57859dec842dd1125ddf2c5c3";
            stable = fetchBootlinToolchain "bfin" "bfin--uclibc--stable-2018.02-2" "41757dafb1360a79451d3d4b3f89bd2ebd8c5a61aeb8f4e445833ff4141bfc20";
        };
    };
    m68k-68xxx = {
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "m68k-68xxx" "m68k-68xxx--uclibc--bleeding-edge-2018.07-3" "26203a2e201a86111abd9249b6d9d26bb196c33f396695b5979a706597a3b424";
            stable = fetchBootlinToolchain "m68k-68xxx" "m68k-68xxx--uclibc--stable-2018.02-2" "fad7682b685a1c7c7d4ab7212535893c41a1e17ac30d64c723587c59b4984359";
        };
    };
    m68k-coldfire = {
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "m68k-coldfire" "m68k-coldfire--uclibc--bleeding-edge-2018.07-3" "b952118ca85d842752eb3548bdbe2306f788348c1a3d2e5dd52bb5f299beaf94";
            stable = fetchBootlinToolchain "m68k-coldfire" "m68k-coldfire--uclibc--stable-2018.02-1" "b89423a8bf2f3f034d3fb45e91f4efa637b347e5264b6aeca0cac9d9c65e51ff";
        };
    };
    microblazebe = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "microblazebe" "microblazebe--glibc--bleeding-edge-2018.07-3" "7251784076718da4fdd4c865d3bc108ff04e362c4e7720500c65cfdc328af624";
            stable = fetchBootlinToolchain "microblazebe" "microblazebe--glibc--stable-2018.02-2" "5b5a311a9db99bd7ab6107ce00eb4a2c9a9a0e3cd32834e861e7912bc40c7176";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "microblazebe" "microblazebe--musl--bleeding-edge-2018.07-3" "1fc74bbdf0fefd1d14ca25fb541bf2a11780fa5da42bfd64940003df963804f3";
            stable = fetchBootlinToolchain "microblazebe" "microblazebe--musl--stable-2018.02-2" "94861b60ffe9f3822c9ea6611a66c26c526784be6b252c7135d3969b20505713";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "microblazebe" "microblazebe--uclibc--bleeding-edge-2018.07-3" "d55ba0b8358e30fd78d74c1b9bd7cffd8428a41e326c4525639cbeb9b7dc85ac";
            stable = fetchBootlinToolchain "microblazebe" "microblazebe--uclibc--stable-2018.02-2" "8793419b5021cb7ebf60b65cbc0b3406b5a810c149cc28682d43a8b2ed8be6ca";
        };
    };
    microblazeel = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "microblazeel" "microblazeel--glibc--bleeding-edge-2018.07-3" "0421ef32a413f417467ae853bf768e57e0a296246092d7af1da81eb19db50072";
            stable = fetchBootlinToolchain "microblazeel" "microblazeel--glibc--stable-2018.02-2" "119be0eabf2fd9890d870b9b1d7eb9c2eb15f5f742744cc0ab5d5f4a1c76bd1e";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "microblazeel" "microblazeel--musl--bleeding-edge-2018.07-3" "4a1f3402fe294c3ae157af241e5d83a55ee86ad52de1ac75360347f4b0fa28fd";
            stable = fetchBootlinToolchain "microblazeel" "microblazeel--musl--stable-2018.02-2" "fe1c427e79bb251f6ddc79b9c03cd2840f2e362a1d0d5a4b9be38041c62cc9a7";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "microblazeel" "microblazeel--uclibc--bleeding-edge-2018.07-3" "e12c0545fc03dbd4ae38fc2a53fc21938263ecec7076013d35e08a91e4bd5e44";
            stable = fetchBootlinToolchain "microblazeel" "microblazeel--uclibc--stable-2018.02-2" "df691a722f4591f7822465949996e5d82514af02da975272cb4e1ea8de53af62";
        };
    };
    mips32 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "mips32" "mips32--glibc--bleeding-edge-2018.07-3" "451870921a6faed7023a51067d2fe25ffb4ccbd0aeb95732dd8666bf9627bdaf";
            stable = fetchBootlinToolchain "mips32" "mips32--glibc--stable-2018.02-2" "1286703a96cf2e29a0a0ad4e8423084991e524e60311d7e4716035064da8dbad";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "mips32" "mips32--musl--bleeding-edge-2018.07-3" "98c0398881d2216437c06a4ba1e2763ec97ea0ae6fccbe796888ea6db1682071";
            stable = fetchBootlinToolchain "mips32" "mips32--musl--stable-2018.02-2" "0c17fa8c2ddcd30d0d2f72b5100378075cb1573ffe8dee418d8a0e4bad0abf4a";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "mips32" "mips32--uclibc--bleeding-edge-2018.07-3" "0cf4c8fdcdbc649caf2e88cf65bde26d5d2563b845be4ce0ad9c81ce60b368a5";
            stable = fetchBootlinToolchain "mips32" "mips32--uclibc--stable-2018.02-2" "abe237b100b1c68acf670877372c57dfebce1f95838d0a9dbe56dfc47775f23a";
        };
    };
    mips32el = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "mips32el" "mips32el--glibc--bleeding-edge-2018.07-3" "8b8b08340d3772cea9188b51ae7c71ba2136a3045e9ded0f405534a8efd24c99";
            stable = fetchBootlinToolchain "mips32el" "mips32el--glibc--stable-2018.02-2" "58c7e3ef0585fdf694b112f2442d40ed79cb85021d301d9e9f4dc3e43d6132ba";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "mips32el" "mips32el--musl--bleeding-edge-2018.07-3" "a055c46b04e148c8dfcf8e6c8ab06297fe845b17c7c64465622e63795dbf5fde";
            stable = fetchBootlinToolchain "mips32el" "mips32el--musl--stable-2018.02-2" "1827dba01865585ccc412dd8b78e952a2dd0ea705b68544ebf239ed893dde951";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "mips32el" "mips32el--uclibc--bleeding-edge-2018.07-3" "518cf902d76a9516390d826efddd534b675371e52e71e30d7de2ca4cd197d0da";
            stable = fetchBootlinToolchain "mips32el" "mips32el--uclibc--stable-2018.02-2" "8ec0c535f0313e62b0b0d91ab535fbf74dd4ff4f59d2af9f60183cb6d158c07c";
        };
    };
    mips32r5el = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "mips32r5el" "mips32r5el--glibc--bleeding-edge-2018.07-3" "d551178e42a8bea782790da23f4c2a6de11f446ceabb02996debc61d5522ef18";
            stable = fetchBootlinToolchain "mips32r5el" "mips32r5el--glibc--stable-2017.05-toolchains-1-20-ge9cdc44-1" "2db7de696564a7ec4ef11f22fbb18e066305860e33692860dfd39cdcf93945c0";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "mips32r5el" "mips32r5el--musl--bleeding-edge-2018.07-3" "88d12ce64bc44d5aea2291b62e44d1b4c5a8cc7414f6581684d633d62ec76469";
            stable = fetchBootlinToolchain "mips32r5el" "mips32r5el--musl--stable-2018.02-2" "bcd8fe98a52a001fef56651e3c31bc0d714334610e550a1fa006e67756d64bf7";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "mips32r5el" "mips32r5el--uclibc--bleeding-edge-2018.07-3" "86e206d4980a99f8d0576eec73e6dfd02331eb86390cb15b4c29507b5bd48866";
            stable = fetchBootlinToolchain "mips32r5el" "mips32r5el--uclibc--stable-2018.02-2" "be7236c1ef834c85d683c4647b2386cc344ec534deb4213636f6d79c04ebf3ed";
        };
    };
    mips32r6el = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "mips32r6el" "mips32r6el--glibc--bleeding-edge-2018.07-3" "9562fcb045fbe83c57d691e5d389bf976dda77d16c5d686ba4ed06b5a9dc5381";
            stable = fetchBootlinToolchain "mips32r6el" "mips32r6el--glibc--stable-2017.05-toolchains-1-1" "1457dbdabe632e87b6b6584870d3843c2d381e81d443c57c872998a8cb7b86f5";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "mips32r6el" "mips32r6el--musl--bleeding-edge-2018.07-3" "1cedb550283a33aaa296278a28659db02a926b3182dc2a4168a6c06e10ff6187";
            stable = fetchBootlinToolchain "mips32r6el" "mips32r6el--musl--stable-2018.02-2" "c190854c19907244eac6ce2b73ea51acc9567d6ab709da55cb95145e3196eb1f";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "mips32r6el" "mips32r6el--uclibc--bleeding-edge-2018.07-3" "2ec7bb36f1f819d4091e65b1bb7ae7ea7ab9e9a2f0a43343e6e5462811c47424";
            stable = fetchBootlinToolchain "mips32r6el" "mips32r6el--uclibc--stable-2018.02-2" "9d5817082f69f6f42f61f7da350d1dd2be0ea3e925422c2ab5da7d3809d63355";
        };
    };
    mips64-n32 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "mips64-n32" "mips64-n32--glibc--bleeding-edge-2018.07-3" "ece01fcb5b8fff10d6802a2d225189ec970b583a44361464fc373dc3ad23cfda";
            stable = fetchBootlinToolchain "mips64-n32" "mips64-n32--glibc--stable-2018.02-2" "3494052de47dc149945205182dd52657d0f2925f4b2343821adc424a6cafaec3";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "mips64-n32" "mips64-n32--musl--bleeding-edge-2018.07-3" "5d42aacd5f443464934806bbde1122885c5b80d3ddcf516d6ee4574466f01493";
            stable = fetchBootlinToolchain "mips64-n32" "mips64-n32--musl--stable-2018.02-2" "43445268f008ca0af39590979318e713b058f3c95be323246dc96fe07d0d6d98";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "mips64-n32" "mips64-n32--uclibc--bleeding-edge-2018.07-3" "8b02b7ec7db021d129776dfeb4013fab2a152ec0706e93d3c5f52802d2a33bb3";
            stable = fetchBootlinToolchain "mips64-n32" "mips64-n32--uclibc--stable-2018.02-2" "fbbb4225dffee34defa9556528caef359a61ecee5b09332905fd5b81a4b9f993";
        };
    };
    mips64el-n32 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "mips64el-n32" "mips64el-n32--glibc--bleeding-edge-2018.07-3" "e6b72fa9ad83364b62bc7d0f1ed2044d532d6801936c0926ea17b7580a8e8d4b";
            stable = fetchBootlinToolchain "mips64el-n32" "mips64el-n32--glibc--stable-2018.02-2" "b9d496506d686e0f40eb27711bcb006a3c9e7b52c82bffdd827fb35554be0a9f";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "mips64el-n32" "mips64el-n32--musl--bleeding-edge-2018.07-3" "6cf914667a9f1441339f2e2a99f34628806920184d4f1489b64530b054d90b39";
            stable = fetchBootlinToolchain "mips64el-n32" "mips64el-n32--musl--stable-2018.02-2" "a8f079eef690e0f14dbe73d7ac2b43aecc531a6f9e2b0dfff395a9fbbf35ec36";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "mips64el-n32" "mips64el-n32--uclibc--bleeding-edge-2018.07-3" "98ef98f2ab6f985794e724b8e3a91c010696c31acb67b8ba966ffbfab07d010a";
            stable = fetchBootlinToolchain "mips64el-n32" "mips64el-n32--uclibc--stable-2018.02-2" "f8f0602196c95e685f890b77c927eaf36037ae5f366087bc8cc7f3604b00e31d";
        };
    };
    mips64r6el-n32 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "mips64r6el-n32" "mips64r6el-n32--glibc--bleeding-edge-2018.07-3" "438840023d4dbd764e02bee1f4f56120c29c43d09962b988e799fe2223e5865c";
            stable = fetchBootlinToolchain "mips64r6el-n32" "mips64r6el-n32--glibc--stable-2017.05-toolchains-1-1" "03f036610504c9dd736c8b216feb9033551cfa5ef2fc3cfb49a75fc733372c0c";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "mips64r6el-n32" "mips64r6el-n32--musl--bleeding-edge-2018.07-3" "6734df3164cd3edc67c9429e91cdd9230369d010a26fe5eda35bbf13ec633552";
            stable = fetchBootlinToolchain "mips64r6el-n32" "mips64r6el-n32--musl--stable-2018.02-2" "df30e48d81b8c8780befe124fd58cdbd47b33907dc7e43ed32e071f5b4f52b2c";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "mips64r6el-n32" "mips64r6el-n32--uclibc--bleeding-edge-2018.07-3" "855d332a4072837c200181518018ca748b6907dcc73c5f5bd5fae80571421fa4";
            stable = fetchBootlinToolchain "mips64r6el-n32" "mips64r6el-n32--uclibc--stable-2018.02-2" "216f4124a351b71e1adc22a949932b5a70807b31f8e48265b809f54fcbdefd41";
        };
    };
    nios2 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "nios2" "nios2--glibc--bleeding-edge-2018.07-3" "2be566269bb90bf4a112ecc551d6c84e633267b93ead4ae30ec11262c7e78b10";
            stable = fetchBootlinToolchain "nios2" "nios2--glibc--stable-2018.02-2" "50cd79b69b9b3e4f6c189e38199831f901cd11801335b7dcc61280e0c441ead5";
        };
    };
    openrisc = {
        musl = {
            stable = fetchBootlinToolchain "openrisc" "openrisc--musl--stable-2018.02-2" "999ab4a021847f93f97f4e5ae096af254e9038d1aefecf3298f57beff14addc1";
        };
        uclibc = {
            stable = fetchBootlinToolchain "openrisc" "openrisc--uclibc--stable-2018.02-2" "883c92c47ccd36480c4d66a3f28ce2ae465e0a34c5291ba40b25259b7f347393";
        };
    };
    powerpc-e500mc = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "powerpc-e500mc" "powerpc-e500mc--glibc--bleeding-edge-2018.07-3" "e8c2c08a7b1536d1ec09b0235b3ddcf28a5cf3e9cf6baa97d7814139e59ffc85";
            stable = fetchBootlinToolchain "powerpc-e500mc" "powerpc-e500mc--glibc--stable-2018.02-2" "1839cd05259d0962ba13a97820ff62cf5813608f95f4801bacb12ba36a70be35";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "powerpc-e500mc" "powerpc-e500mc--musl--bleeding-edge-2018.07-3" "efe859e2586d304544e009a5effc82e09374e6377af5d420883fda9c84d4ac6f";
            stable = fetchBootlinToolchain "powerpc-e500mc" "powerpc-e500mc--musl--stable-2018.02-2" "6398d338f7b1f2a0ac1c0a8e5d85a39a276d5ec5664e30e90219373c4ff5ca7d";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "powerpc-e500mc" "powerpc-e500mc--uclibc--bleeding-edge-2018.07-3" "25e3b56ab079db90157e1ae512e025382986ea0be1b4af0c313e10ab4912bfdd";
            stable = fetchBootlinToolchain "powerpc-e500mc" "powerpc-e500mc--uclibc--stable-2018.02-2" "4a58d771108756293c99708947bb75f16a8f2b359a038691a5cc905618f99a26";
        };
    };
    powerpc64-e5500 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "powerpc64-e5500" "powerpc64-e5500--glibc--bleeding-edge-2018.07-3" "0bae883d517958649c8a82bc17cecc742b010f19bceb75e9c34dc6e4903fc3e9";
            stable = fetchBootlinToolchain "powerpc64-e5500" "powerpc64-e5500--glibc--stable-2018.02-2" "ff178f633d2085e64561e96d94331a1acd9ff0a990601c3243467aff56f7de22";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "powerpc64-e5500" "powerpc64-e5500--musl--bleeding-edge-2018.07-3" "8eeb91f17bd0b4c1573d55b0c6d03d87ea537a6fa2c8245a3608d48875fa0913";
            stable = fetchBootlinToolchain "powerpc64-e5500" "powerpc64-e5500--musl--stable-2018.02-2" "1ac779f0728d924791f53d3e73dabf4450fbfab03810fb4958addf10d71e2be6";
        };
    };
    powerpc64-power8 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "powerpc64-power8" "powerpc64-power8--glibc--bleeding-edge-2018.07-3" "871286485703799f266887fa7b6becaad8df0c015141d715ec5599c000e779ac";
            stable = fetchBootlinToolchain "powerpc64-power8" "powerpc64-power8--glibc--stable-2018.02-2" "b6d451dd2c592aefb6ffd7f85d64aa836a0782099912ef929e9db56b7068731b";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "powerpc64-power8" "powerpc64-power8--musl--bleeding-edge-2018.07-3" "887b7a74b8f53b0115114cac5f97b68090a122cd63daf7829bd428db980fe270";
            stable = fetchBootlinToolchain "powerpc64-power8" "powerpc64-power8--musl--stable-2018.02-2" "b905718a316e2cab0d6bc0eacc6cdf1f0d3f8a6511cb16715f67786f525f3a81";
        };
    };
    powerpc64le-power8 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "powerpc64le-power8" "powerpc64le-power8--glibc--bleeding-edge-2018.07-3" "7c1cc992041052870d16cf2a7842562f6490365748724e7786084d2fea31c2fd";
            stable = fetchBootlinToolchain "powerpc64le-power8" "powerpc64le-power8--glibc--stable-2018.02-2" "180894a8e2e8a9a3f5aa1a9790f6d19205e6278733566d40698549c4a995d852";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "powerpc64le-power8" "powerpc64le-power8--musl--bleeding-edge-2018.07-3" "c046f0d5da579baa22184ff19b2cbbac51921325a1fcec6ffc4f7ffaa1cbebe9";
            stable = fetchBootlinToolchain "powerpc64le-power8" "powerpc64le-power8--musl--stable-2018.02-2" "efec8704a12d738a1ff169a61eceb0eee06ee66f1520ff58b168453cb162642d";
        };
    };
    sh-sh4 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "sh-sh4" "sh-sh4--glibc--bleeding-edge-2018.07-3" "2a3baea624ea8a38b819953c8c8e38a366445532988b0e85f126c5ad4936f306";
            stable = fetchBootlinToolchain "sh-sh4" "sh-sh4--glibc--stable-2018.02-2" "31ca071d75e760c70216bb39c1a7efa6cef8db94326f323e56d787330daa2109";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "sh-sh4" "sh-sh4--musl--bleeding-edge-2018.07-3" "c7daad646401f241f4c7f497ef06a70112975bc692bdd5f101cac30558ec46dc";
            stable = fetchBootlinToolchain "sh-sh4" "sh-sh4--musl--stable-2018.02-2" "f54ea354cd93b4a5606ebf7a03f61fbc15de25b7bcd979c0559fd373ea478cfe";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "sh-sh4" "sh-sh4--uclibc--bleeding-edge-2018.07-3" "6852d7f2734079a17ec50b593f9b6cf12fa1c1fdc6141ddb031b04eb5c69930d";
            stable = fetchBootlinToolchain "sh-sh4" "sh-sh4--uclibc--stable-2018.02-2" "854948c9611bdff2e09ef4c29226287e1717f455d8bb719aff5f4e42f5927619";
        };
    };
    sh-sh4aeb = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "sh-sh4aeb" "sh-sh4aeb--glibc--bleeding-edge-2018.07-3" "f3c5998badb09f345e875647ac20e2da698102be45b6a53a117295bcd689b5fd";
            stable = fetchBootlinToolchain "sh-sh4aeb" "sh-sh4aeb--glibc--stable-2018.02-2" "eebd3189a5fe9b68a535cc0fc80d7b737a3288e8fc4de6dbe4abdea5150592f2";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "sh-sh4aeb" "sh-sh4aeb--musl--bleeding-edge-2018.07-3" "0ed6955f17edb51b5ed86b8f912aa9cddaa875ad2ecb2b6a278567a8b28abf0d";
            stable = fetchBootlinToolchain "sh-sh4aeb" "sh-sh4aeb--musl--stable-2018.02-2" "2d24b3fb386d83cf7163a4938657230a326cf7f9c8da916cc9fbbb5f6d757e08";
        };
    };
    sparc64 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "sparc64" "sparc64--glibc--bleeding-edge-2018.07-3" "7f37d4203b501b4f903eeb52df27a02ad864b4a102fd9ed07999fc625f554ea3";
            stable = fetchBootlinToolchain "sparc64" "sparc64--glibc--stable-2018.02-2" "fb65331c9fef45a30fee47fdb8d2d3393abd36d79eeaddb23575a799e2e2c4af";
        };
    };
    sparcv8 = {
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "sparcv8" "sparcv8--uclibc--bleeding-edge-2018.07-3" "17003c23a248056c20e051378c969911094d64ccdc9ff456ac11ca9b498ba034";
            stable = fetchBootlinToolchain "sparcv8" "sparcv8--uclibc--stable-2018.02-2" "18617cea70ec083e17bf469030118172fdb4c1dac30d3a9d74a81cf382af7aa8";
        };
    };
    x86-64-core-i7 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "x86-64-core-i7" "x86-64-core-i7--glibc--bleeding-edge-2018.07-3" "e7235db3b23cffc2855f6b507bec1c648211879f703ce8e2e86b0816d30c0853";
            stable = fetchBootlinToolchain "x86-64-core-i7" "x86-64-core-i7--glibc--stable-2018.02-2" "2e2e60ddf593aaea4dace384b46c1132a66a4e182975194efc02407f8adf75d1";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "x86-64-core-i7" "x86-64-core-i7--musl--bleeding-edge-2018.07-3" "819065a99b188d82c93535e9904df84e5324a99ea0351d9c29a3df43efab3bd8";
            stable = fetchBootlinToolchain "x86-64-core-i7" "x86-64-core-i7--musl--stable-2018.02-2" "32c2e27d7037ca106e67997a0b43f1763e0971a28240bbde7b0e98e053ba2add";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "x86-64-core-i7" "x86-64-core-i7--uclibc--bleeding-edge-2018.07-3" "d0919cc92e7218d66366954cf75978238b0032eb55a157bad949071859928cfa";
            stable = fetchBootlinToolchain "x86-64-core-i7" "x86-64-core-i7--uclibc--stable-2018.02-2" "6f1c4da4334d36156a5e6f82438155bc0742b9f3a5a9263e507813b86de558ac";
        };
    };
    x86-core2 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "x86-core2" "x86-core2--glibc--bleeding-edge-2018.07-3" "8ece5582f7b951cf7ab7c23e18ea4613931e0f760cd879ec4d4a9bb00ff3be45";
            stable = fetchBootlinToolchain "x86-core2" "x86-core2--glibc--stable-2018.02-2" "17148fa13aab1c8ae6620ea5af0c9a53afe2d2af9719eb50fd1172fde185c586";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "x86-core2" "x86-core2--musl--bleeding-edge-2018.07-3" "67ea2b06437de13b275a8d07e9b2997df27553d45e8111a34791256170adea82";
            stable = fetchBootlinToolchain "x86-core2" "x86-core2--musl--stable-2018.02-2" "3f21c594187d3b6cff1def39da867f2c1830cc8157f4564908dca026dd80b73f";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "x86-core2" "x86-core2--uclibc--bleeding-edge-2018.07-3" "40ba7470dc53734884c469c9ba95e49d4f4d802e0aab4d3f3883b3a1dc5e973d";
            stable = fetchBootlinToolchain "x86-core2" "x86-core2--uclibc--stable-2018.02-2" "09be8169389b6d575e5ef3b3c192813e98f1f9ccd64a6d8b5f6a1e5b149e075f";
        };
    };
    x86-i686 = {
        glibc = {
            bleeding-edge = fetchBootlinToolchain "x86-i686" "x86-i686--glibc--bleeding-edge-2018.07-3" "585bdf5bd84d9f5ff535daa80d182b16c9bffb74fe9fb8fd6464e7d7fd311428";
            stable = fetchBootlinToolchain "x86-i686" "x86-i686--glibc--stable-2018.02-2" "d00ef0f101aed2f61f8f81a6ce61f4015c1a8493eaa526857791e90e6bf0173b";
        };
        musl = {
            bleeding-edge = fetchBootlinToolchain "x86-i686" "x86-i686--musl--bleeding-edge-2018.07-3" "511d69d7c0dde49f09b5af0fc6355e5148f295520c21dfcc2f3720dc76b490a9";
            stable = fetchBootlinToolchain "x86-i686" "x86-i686--musl--stable-2018.02-2" "7a85e9cbdadcf6befed4ab9c30a60a0d6d6ffe1aa13b08a50611fc1e4f604891";
        };
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "x86-i686" "x86-i686--uclibc--bleeding-edge-2018.07-3" "9fcde45fedd77be67d3315c67a4464436654cc5434f785d1f3f6e2b492237549";
            stable = fetchBootlinToolchain "x86-i686" "x86-i686--uclibc--stable-2018.02-1" "587d09cbcd719910862d96b259aed8663ef2c292f3a02b9f8ba4e95a2c353c6f";
        };
    };
    xtensa-lx60 = {
        uclibc = {
            bleeding-edge = fetchBootlinToolchain "xtensa-lx60" "xtensa-lx60--uclibc--bleeding-edge-2018.07-3" "8c5fe28bd7cc6e06ea4417486b501df1cd96a948f29f5258b2b2c6a823a4a893";
            stable = fetchBootlinToolchain "xtensa-lx60" "xtensa-lx60--uclibc--stable-2018.02-2" "d414333fbec2897eeaa3e8ec2792a90872f62b9f7567e5f9427fde7a64fc9672";
        };
    };
}
