{ inputs, ... }:

let
  inherit (inputs) dotfiles;

in {
  services.xserver.extraLayouts = {
    colemak-bs_cl = {
      description = "Colemak Layout with BackSpace and Caps Lock swapped";
      languages = [ "eng" ];
      symbolsFile = "${dotfiles}/config/xkbmap/colemak-bs_cl";
    };
    dvorak-bs_cl = {
      description = "Dvorak Layout with BackSpace and Caps Lock swapped";
      languages = [ "eng" ];
      symbolsFile = "${dotfiles}/config/xkbmap/dvorak-bs_cl";
    };
  };
}
