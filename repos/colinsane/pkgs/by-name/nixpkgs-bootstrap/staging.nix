{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "eb655bcfcd8f74f534698745d0c9547c1df9e4fe";
  sha256 = "sha256-woSpeexidjwGT/gB01wIaY6JLociphDBeeg29TtATY0=";
  version = "unstable-2025-11-30";
  branch = "staging";
}
