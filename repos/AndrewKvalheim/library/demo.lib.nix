{ lib, pkgs }:

let
  inherit (builtins) head mapAttrs stringLength substring tail;
  inherit (lib) concatLines concatMapStringsSep concatStringsSep filterAttrs mapAttrsToList toUpper;
  inherit (import ./identity.lib.nix { inherit lib; }) contactNotice;
  inherit (import ./palette.lib.nix { inherit lib; inherit pkgs; }) colors;
  inherit (import ./utilities.lib.nix { inherit lib; }) ansiColorNames compose sgr;

  # Pending NixOS/nixpkgs#402372
  toCamelCase = s: "${substring 0 6 s}${toUpper (substring 7 1 s)}${substring 8 (stringLength s) s}";
in
{
  inherit contactNotice;

  palette = with sgr; concatLines (mapAttrsToList
    (name: { css, hex, sgr, ... }: "${sgr "██ ${name}"} ${brightBlack "${css} ≈ ${hex}"}")
    (filterAttrs (_: a: a ? css) colors)
  );

  sgr =
    let
      nest = nss:
        let ns = head nss; nss' = tail nss; l = "‹${concatStringsSep "-" ns}›"; in
        (compose (map (n: sgr.${n}) ns)) (if nss' == [ ] then l else "${l}${nest nss'}${l}");
    in
    with mapAttrs (n: _: n) sgr; ''
           Color: ${concatMapStringsSep " " (n: sgr.${n} "‹${n}› ") ansiColorNames}
                  ${concatMapStringsSep " " (n: sgr.${toCamelCase "bright-${n}"} "‹${n}+›") ansiColorNames}
       Intensity: ${nest [[ bold ]]} ${nest [[ dim ]]}
           Style: ${nest [[ italic ]]}
      Decoration: ${nest [[ underline ]]} ${nest [[ doubleUnderline ]]} ${nest [[ strike ]]}
          Effect: ${nest [[ inverse ]]}

            Nest: ${nest [[ blue ] [ bold ]]}      ${nest [[ bold ] [ blue ]]}
                  ${nest [[ blue ] [ dim ]]}       ${nest [[ dim ] [ blue ]]}
                  ${nest [[ blue ] [ italic ]]}    ${nest [[ italic ] [ blue ]]}
                  ${nest [[ blue ] [ underline ]]} ${nest [[ underline ] [ blue ]]}
                  ${nest [[ blue ] [ strike ]]}    ${nest [[ strike ] [ blue ]]}
                  ${nest [[ blue ] [ inverse ]]}   ${nest [[ inverse ] [ blue ]]}

                  ${nest [[ blue ] [ bold ] [ italic ]]}
                  ${nest [[ bold ] [ italic ] [ blue ]]}
                  ${nest [[ italic ] [ blue ] [ bold ]]}

                  ${nest [[ dim ] [ inverse ]]}
                  ${nest [[ inverse ] [ dim ]]}

         Compose: ${nest [[ bold blue ]]} ${nest [[ italic blue ]]} ${nest [[ bold italic ]]}
                  ${nest [[ blue bold ]]} ${nest [[ blue italic ]]} ${nest [[ italic bold ]]}

                  ${nest [[ blue ] [ bold italic ]]}
                  ${nest [[ bold ] [ italic blue ]]}
                  ${nest [[ italic ] [ blue bold ]]}

                  ${nest [[ bold italic blue ]]}
                  ${nest [[ strike ] [ bold italic blue ]]}
                  ${nest [[ inverse strike ] [ bold italic blue ]]}

                  ${nest [[ italic blue ] [ bold dim ]]}
                  ${nest [[bold dim] [ italic blue ]]}

                  ${nest [[ italic blue ] [ bold underline ] [ inverse strike ]]}

                  ${nest [[ blue bold dim italic underline strike inverse ]]}
                  ${nest [[ inverse strike underline italic dim bold blue ]]}
    '';
}
