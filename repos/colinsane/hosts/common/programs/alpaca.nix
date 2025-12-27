# alpaca: ollama llm client
# - super simple, easy UI
#
# shortcomings (as of 6.1.7, 2025-07-23):
# - doesn't seem to do any prompt tuning;
#   inherits all the pathologies of the underlying model (e.g. makes up citations)
#
# it creates a config dir, `~/.config/com.jeffser.Alpaca`, but apparently empty.
# the actual config (and chat state) is held in a relatively simple sqlite database.
{ config, pkgs, ... }:
let
  defaultInstanceId = "20250727030639850585cfd40bab6b83425885caa00a198c9983";
  defaultHost = if config.networking.hostName == "desko" then
    "http://127.0.0.1:11434"
  else
    "http://${config.sane.hosts.by-name.desko.wg-home.ip}:11434"
  ;
  defaultModel = "gemma3:27b";
  defaultDb = pkgs.runCommand "alpaca-default-db" {
    nativeBuildInputs = with pkgs; [
      sqlite
    ];
  } ''
    # schema taken from <repo:jeffser/Alpaca:src/sql_manager.py>
    sqlite3 alpaca.db '
      CREATE TABLE instance (
        id TEXT NOT NULL PRIMARY KEY,
        pinned INTEGER NOT NULL,
        type TEXT NOT NULL,
        properties TEXT NOT NULL
      );
      INSERT INTO instance (id, pinned, type, properties) VALUES (
        "${defaultInstanceId}",
        0,
        "ollama",
        '"'"'{"name": "desko", "url": "${defaultHost}", "api": "ollama", "override_parameters": true, "temperature": 0.7, "seed": 0.0, "num_ctx": 16384.0, "keep_alive": 300, "default_model": "${defaultModel}", "title_model": null, "think": false, "share_name": 0, "show_response_metadata": false}'"'"'
    )
    '

    mkdir $out
    cp alpaca.db $out
  '';
in
{
  sane.programs.alpaca = {
    packageUnwrapped = (pkgs.alpaca.override {
      # ollama is only added to `PATH`; since i'm using it via http, remove it here.
      # fixes cross compilation & simplifies closure.
      ollama = null;
      python3Packages = pkgs.python3Packages.overrideScope (self: super: {
        markitdown = null;  #< XXX(2025-12-07): does not cross compile (markitdown -> speechrecognition -> onnxruntime)
        opencv4 = null;  #< XXX(2025-10-11): doesn't cross compile. or, fails at import time: "OpenCV loader: missing configuration file: ..."
        rembg = null;  #< XXX(2025-10-11): pulls in opencv, which doesn't cross compile; marked as optional-dependency
        openai-whisper = null;  #< XXX(2025-10-11): doesn't cross compile; marked as optional-dependency
        spacy-models.en_core_web_sm = null;  #< XXX(2025-10-11): doesn't cross compile; marked as optional-dependency
        kokoro = null;  #< XXX(2025-10-11): doesn't cross compile; marked as optional-dependency
      });
    }).overrideAttrs (upstream: {
      # add missing direct dependencies that were previously smuggled via
      # one of the null'd dependencies above.
      propagatedBuildInputs = upstream.propagatedBuildInputs ++ [
        pkgs.python3Packages.beautifulsoup4
      ];

      postPatch = (upstream.postPatch or "") + ''
        substituteInPlace data/meson.build \
          --replace-fail \
            "('glib-compile-schemas', required: true, disabler: true)" \
            "('glib-compile-schemas', required: true, disabler: true, native: true)"

        # for nulled dependencies (above), patch so the application only errors
        # at runtime, on first attempted use.
        substituteInPlace src/widgets/attachments.py \
          --replace-fail 'from markitdown'  '# from markitdown'
        substituteInPlace src/widgets/activities/web_browser.py \
          --replace-fail 'from markitdown'  '# from markitdown'
        substituteInPlace src/widgets/blocks/table.py \
          --replace-fail 'import pandas'  '# inport pandas'

        substituteInPlace src/widgets/activities/camera.py \
          --replace-fail 'import cv2,'  'import'
      '';

      passthru = (upstream.passthru or {}) // {
        inherit defaultDb;
      };
    });
    buildCost = 2;  #< liable to break cross during updates; not important enough to block deploy over

    sandbox.net = "all";  # maybe only needs wireguard, actually
    sandbox.whitelistWayland = true;
    sandbox.matplotlibCacheDir = ".cache/com.jeffser.Alpaca/matplotlib";
    sandbox.mesaCacheDir = ".cache/com.jeffser.Alpaca/mesa";

    sandbox.whitelistDbus.user.own = [
      "com.jeffser.Alpaca"
      "com.jeffser.Alpaca.Service"
    ];
    sandbox.whitelistPortal = [
      "OpenURI"
    ];
    sandbox.whitelistSendNotifications = true;

    # persist.byStore.private = [
    #   # alpaca.db: sqlite3 database with the following tables:
    #   # - attachment
    #   # - chat
    #   # - instances
    #   # - message
    #   # - model_preferences
    #   # - preferences
    #   # - tool_parameters
    #   ".local/share/com.jeffser.Alpaca"
    # ];

    # N.B.: needs to be a file, not a symlink, else Alpaca crashes on launch.
    fs.".local/share/com.jeffser.Alpaca/alpaca.db".file.copyFrom = "${defaultDb}/alpaca.db";

    gsettings."com/jeffser/Alpaca" = {
      skip-welcome = true;
      last-notice-seen = "Alpaca8";
      selected-instance = defaultInstanceId;
    };
    # gsettingsPersist = [ "com/jeffser/Alpaca" ];  # for `selected-instance`
  };
}
