{ pkgs
, chromium-pkg ? pkgs.brave
, extra-extensions ? [ ] }:

{
  programs.chromium = {
    enable = true;
    package = chromium-pkg;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
      "pmcmeagblkinmogikoikkdjiligflglb" # Privacy Redirect
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
      "hjdoplcnndgiblooccencgcggcoihigg" # Terms of Service; Didn’t Read
    ] ++ extra-extensions;
  };
}
