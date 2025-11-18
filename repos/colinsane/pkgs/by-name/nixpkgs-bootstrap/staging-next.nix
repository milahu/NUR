{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "a1906140cb424e950bd442728b0c5e918238a3bc";
  sha256 = "sha256-bmhbv82/BPG++Cc8/0mSlWPDFJlnxiKeV4PkUe1WXFA=";
  version = "unstable-2025-11-17";
  branch = "staging-next";
}
