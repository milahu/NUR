{ lib }:

let
  inherit (builtins) add all attrValues head isFunction listToAttrs mapAttrs split stringLength substring tail;
  inherit (lib) concatLines fixedWidthNumber flip fold id imap0 isList max nameValuePair pipe removeSuffix splitString throwIf throwIfNot toHexString toUpper;
  inherit (lib.strings) replicate;
  inherit (import <nix-math> { inherit lib; }) cos pi pow round sin;

  # Pending NixOS/nixpkgs#402372
  toCamelCase = s: "${substring 0 6 s}${toUpper (substring 7 1 s)}${substring 8 (stringLength s) s}";
in
rec {
  ansiColorNames = [ "black" "red" "green" "yellow" "blue" "magenta" "cyan" "white" ];

  # Adapted from https://en.wikipedia.org/wiki/Clenshaw_algorithm#Special_case_for_Chebyshev_series
  chebyshev = coefficients: x:
    let
      a0 = head coefficients;
      recurrence = a: { b1, b2 }: { b1 = a + 2.0 * x * b1 - b2; b2 = b1; };
      inherit (fold recurrence ({ b1 = 0; b2 = 0; }) (tail coefficients)) b1 b2;
      b0 = 2.0 * x * b1 - b2;
    in
    0.5 * (a0 + b0 - b2);

  chebyshevWithDomain = beginning: end: coefficients: x:
    chebyshev coefficients (-1.0 + 2.0 * (x - beginning) / (end - beginning));

  compose = flip pipe;

  # Adapted from https://www.w3.org/WAI/WCAG22/Techniques/general/G18
  contrastRatio = linearRgb1: linearRgb2:
    let
      linearRgbToRelativeLuminance = { r, g, b }: 0.2126 * r + 0.7152 * g + 0.0722 * b;
      flare = 0.05;
      ratio = light: dark: (light + flare) / (dark + flare);

      l1 = linearRgbToRelativeLuminance linearRgb1;
      l2 = linearRgbToRelativeLuminance linearRgb2;
    in
    if l1 < l2 then ratio l2 l1 else ratio l1 l2;

  csi = final: params: "[${params}${final}";

  findHighest = accept: resolution: low: high:
    if high - low < resolution then
      throwIfNot (accept low) "Lower bound ${toString low} fails acceptance test" low
    else
      let half = low + (high - low) * 0.5; in
      if accept half then findHighest accept resolution half high
      else findHighest accept resolution low half;

  findLowest = accept: resolution: low: high:
    if high - low < resolution then
      throwIfNot (accept high) "Upper bound ${toString high} fails acceptance test" high
    else
      let half = low + (high - low) * 0.5; in
      if accept half then findLowest accept resolution low half
      else findLowest accept resolution half high;

  frame = color: text:
    let
      lines = splitString "\n" (removeSuffix "\n" text);
      pad = printablePad (fold max 0 (map printableLength lines));
    in
    concatLines ([
      (color "┌───${pad "─" ""}───┐")
      (color "│   ${pad " " ""}   │")
    ] ++ map (l: "${color "│"}   ${pad " " l}   ${color "│"}") lines ++ [
      (color "│   ${pad " " ""}   │")
      (color "└───${pad "─" ""}───┘")
    ]);

  # Adapted from https://bottosson.github.io/posts/colorwrong/#what-can-we-do%3F
  linearRgbToRgb = mapAttrs (_: u: if u > 0.0031308 then 1.055 * pow u (1 / 2.4) - 0.055 else 12.92 * u);

  mkSgr = off: on: text: "${csi "m" on}${text}${csi "m" off}";

  oklchToCss = { l, c, h }: "oklch(${toString l} ${toString c} ${toString h})";

  oklchToLinearRgb = target:
    let
      convert = { l, c, h }:
        let
          # Adapted from https://drafts.csswg.org/css-color-4/#color-conversion-code
          a = c * cos (h * pi / 180);
          b = c * sin (h * pi / 180);

          # Adapted from https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab
          long = pow (l + 0.3963377774 * a + 0.2158037573 * b) 3;
          medium = pow (l - 0.1055613458 * a - 0.0638541728 * b) 3;
          short = pow (l - 0.0894841775 * a - 1.2914855480 * b) 3;
          rgb = {
            r = 4.0767416621 * long - 3.3077115913 * medium + 0.2309699292 * short;
            g = -1.2684380046 * long + 2.6097574011 * medium - 0.3413193965 * short;
            b = -0.0041960863 * long - 0.7034186147 * medium + 1.7076147010 * short;
          };
        in
        if all (u: 0 <= u && u <= 1) (attrValues rgb) then rgb else null;

      result = convert target;
      inGamut = c: convert (target // { inherit c; }) != null;
      clamped = target // { c = findHighest inGamut 0.0000005 0 0.37; };
    in
    throwIf (result == null)
      "Not representable in sRGB\n   Target: ${oklchToCss target}\n  Clamped: ${oklchToCss clamped}"
      result;

  printableLength = text: fold add 0 (map (v: if isList v then 0 else stringLength v) (split "\\[[^m]*m" text));

  printablePad = width: placeholder: text: text + replicate (width - printableLength text) placeholder;

  rgbToHex = { r, g, b }:
    let f = x: fixedWidthNumber 2 (toHexString (round (x * 255)));
    in "#${f r}${f g}${f b}";

  rgbToCssRgba = rgb: a: with mapAttrs (_: v: toString (round (v * 255))) rgb; "rgba(${r}, ${g}, ${b}, ${toString a})";

  rgbToSgr = rgb: with mapAttrs (_: v: toString (round (v * 255))) rgb; mkSgr "39" "38;2;${r};${g};${b}";

  sgr =
    let
      mkColors = f: b: listToAttrs (imap0 (i: n: nameValuePair (f n) { off = "39"; on = toString (b + i); }) ansiColorNames);

      f = p: f':
        if f' == null then p
        else if isFunction f' then let p' = f' null; in f { off = "${p'.off};${p.off}"; on = "${p.on};${p'.on}"; }
        else mkSgr p.off p.on f';
    in
    mapAttrs (_: f) (mkColors id 30 // mkColors (n: toCamelCase "bright-${n}") 90 // {
      bold = { off = "22"; on = "1"; };
      dim = { off = "22"; on = "2"; };
      doubleUnderline = { off = "24"; on = "21"; };
      inverse = { off = "27"; on = "7"; };
      italic = { off = "23"; on = "3"; };
      strike = { off = "29"; on = "9"; };
      underline = { off = "24"; on = "4"; };
    });
}
