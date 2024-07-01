{ lib, pkgs }:

{
  eevee = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./eevee;
  };

  eppa = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./eppa;
  };

  fotoente = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./fotoente;
  };

  olivvybee =
    let
      mkEmojiPack = pkgs.callPackage ./olivvybee/mkEmojiPack.nix { };
    in
    {
      inherit mkEmojiPack;
    }
    // builtins.mapAttrs (name: hash: mkEmojiPack { inherit name hash; }) {
      blobbee = "sha256-4L3jd80OWndy0ZYMYAd1wMGzQOurkAVmH1uazKPzKjM=";
      fox = "sha256-EbEfbffz+MdVF33x7nP59je20xsq1+pkGeyTJVtKDTA=";
      neobread = "sha256-IsFYobxBq7IsqW1pIa7ApwN8AnigTk6oWraIMi/o9W8=";
      neocat = "sha256-Tsuh8c32fq8jZDjYLtfgeORtgzIivyDq/DHFDJT+Yr4=";
      neodlr = "sha256-4algyDuhPgmm7BGuaPQCEeZOcQYWB0eMQ5jY1bpgNeU=";
      neofox = "sha256-AvnM27ovf7AfeHSa4MmrVLjzBzLGOgY5dVesmb0LkQs=";
      neossb = "sha256-+4pHxLriFcB8Ryq44nim4sn4E7ENVaMEftsda67Vt7c=";
    };

  renere = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./renere;
  };

  volpeon =
    let
      mkEmojiPack = pkgs.callPackage ./volpeon/mkEmojiPack.nix { };
    in
    {
      inherit mkEmojiPack;
    }
    // builtins.mapAttrs (name: { version, hash }: mkEmojiPack { inherit name version hash; }) {
      drgn = {
        version = "3.1";
        hash = "sha256-9SdjY51jeAIKz+CP2I1IL9d2EwN+NWAfuM+3FAMi4Oo=";
      };
      floof = {
        version = "1.0";
        hash = "sha256-N8A5YqpJK2vz+aGRQ40l+V39w6SNE3JLNyVxZxNkVIo=";
      };
      gphn = {
        version = "1.2";
        hash = "sha256-p1MT/u7pzx2UBLQuVD0dMmZ/uacVN6fTOrTzqLZNkts=";
      };
      neocat = {
        version = "1.1";
        hash = "sha256-FLtaIqBZqZGC51NX6HiwEzWBlx1GpstZcgpnMDFTuQk=";
      };
      neofox = {
        version = "1.3";
        hash = "sha256-zHbiRiEOwGlmm9TRvL25ngCK04rJHzYsLxz2PUjf3GA=";
      };
      vlpn = {
        version = "1.1";
        hash = "sha256-NNBNGS9S2iZCj76xJ6PJdxyHCfpP+yoYVuX8ORzpYrs=";
      };
    };
}