final: prev:
(import ../pkgs { pkgs = prev; }).sanePkgsOverlay final prev // {
  sane = import ../pkgs { pkgs = final; };
}
