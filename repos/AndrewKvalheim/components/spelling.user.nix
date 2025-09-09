{ config, ... }:

let
  inherit (builtins) hashString readFile toFile toJSON;
  inherit (config) host;

  words =
    (readFile ./assets/words.txt) +
    (readFile (host.dir + "/assets/words.local.txt"));

  formats = {
    chromium = toFile "words-chromium" (words + "checksum_v1 = ${hashString "md5" words}");
    plaintext = toFile "words-plaintext" words;
  };
in
{
  # Chromium
  xdg.configFile."chromium/Default/Custom Dictionary.txt".source = formats.chromium;

  # CSpell
  home.file.".cspell.json".text = toJSON {
    dictionaries = [ "custom" ];
    dictionaryDefinitions = [{ name = "custom"; path = formats.plaintext; }];
    enableFiletypes = [ "env" "haml" "liquid" "nix" "ruby" "shellscript" "xml" ];
  };

  # Firefox
  home.file.".mozilla/firefox/${host.firefox.profile}/persdict.dat".source = formats.plaintext;

  # Joplin
  xdg.configFile."Joplin/Custom Dictionary.txt".source = formats.chromium;

  # VSCodium
  programs.vscode.profiles.default.userSettings = {
    "cSpell.minWordLength" = 2;
    "cSpell.customDictionaries" = {
      custom = { path = formats.plaintext; };
      custom-coffeescript = { path = ./assets/words-coffeescript.txt; };
      custom-css = { path = ./assets/words-css.txt; };
      custom-nix = { path = ./assets/words-nix.txt; };
      custom-rust = { path = ./assets/words-rust.txt; };
      custom-shellscript = { path = ./assets/words-shellscript.txt; };
    };
    "cSpell.languageSettings" = [
      { languageId = "coffeescript"; dictionaries = [ "custom-coffeescript" ]; }
      { languageId = "css"; dictionaries = [ "custom-css" ]; }
      { languageId = "nix"; dictionaries = [ "custom-nix" ]; }
      { languageId = "rust"; dictionaries = [ "custom-rust" ]; }
      { languageId = "shellscript"; dictionaries = [ "custom-shellscript" ]; }
    ];
  };
}
