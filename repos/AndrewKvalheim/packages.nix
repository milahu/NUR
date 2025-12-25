resolved: stable:

with import ./library/override-utils.lib.nix { inherit stable; nur = ./nur.nix; search = [ "unstable" "unstable-small" ]; };

let
  inherit (lib) findFirst hasInfix makeBinPath recursiveUpdate throwIf versionAtLeast versionOlder;
  inherit (stable) fetchurl lib;

  community-vscode-extensions = (import <community-vscode-extensions>).extensions.${stable.stdenv.hostPlatform.system}.forVSCodeVersion resolved.vscodium.version;
  open-vsx = { _name = "open-vsx"; vscode-extensions = community-vscode-extensions.open-vsx; };
  vscode-marketplace = { _name = "vscode-marketplace"; vscode-extensions = community-vscode-extensions.vscode-marketplace; };
in
specify {
  add-words = any;
  aegisub.overlay = a: throwIf (a.version != "3.4.2") "aegisub overlay is outdated" {
    version = "3.4.2-unstable-2025-12-01";
    src = a.src.override (_: { tag = null; rev = "1ad6844de46159a7db66da163992ddd598e1b9c7"; hash = "sha256-70qIs/MASVtQHl2580C3iv9Do2G9JNptGnpjk765L7A="; });
    postPatch = a.postPatch + "patchShebangs 'tools/combine-config.py'";
  }; # Pending TypesettingTools/Aegisub#309 via ≥3.5
  affine-font = any;
  album-art = any;
  ansible-lint.overlay = a: recursiveUpdate a { meta.broken = versionOlder (findFirst (p: p.pname == "ansible-compat") null a.passthru.dependencies).version "25.8"; }; # NixOS/nixpkgs#460422
  ansible-vault-pass-client = any;
  apex = any;
  attachments = any;
  aws-sam-cli = { version = "≠1.143.0"; search = pin "e6f23dc08d3624daab7094b701aa3954923c6bbb" "sha256-3a7Tha/RwYlzH/v3PJrG7+HjOj4c6YOv2K8sqdGsHVQ="; }; # Pending NixOS/nixpkgs#459334
  blocky-ui = any;
  busyserve = any;
  caddy-with-route53 = any;
  cavif = any;
  ch57x-keyboard-tool = any;
  chromium.commandLineArgs = "--enable-features=WaylandTextInputV3"; # Pending https://crbug.com/40272818, NixOS/nixpkgs#394395
  co2monitor = any;
  decompiler-mc = any;
  dmarc-report-converter = any;
  dmarc-report-notifier = any;
  email-hash = any;
  emote.overlay = e: { postInstall = e.postInstall or "" + "\nsubstituteInPlace $out/share/applications/com.tomjwatson.Emote.desktop --replace-fail 'Exec=emote' \"Exec=$out/bin/emote\""; }; # Allow desktop entry as entrypoint
  espressif-serial = any;
  fastnbt-tools = any;
  fediblockhole = any;
  filter-imf = any;
  firefox.overlay = w: { makeWrapperArgs = w.makeWrapperArgs ++ [ "--unset" "LC_TIME" ]; }; # Workaround for bugzilla#1269895
  git-diff-image = any;
  git-diff-minecraft = any;
  git-remote = any;
  gnome-shell = { patch = [ ./library/assets/gnome-shell_accent-color.patch ./library/assets/gnome-shell_screenshot-location.patch ]; ccache = true; }; # Pending GNOME/gnome-shell#5370
  gnomeExtensions.launcher.patch = [ ./library/assets/gnome-extension-launcher_icon.patch ./library/assets/gnome-extension-launcher_hide-settings.patch ];
  gopass-await = any;
  gopass-env = any;
  gopass-ydotool = any;
  gpx-reduce = any;
  graalvmPackages.graaljs.overlay = g: throwIf (hasInfix "jvm" g.src.url) "graaljs no longer requires an overlay" { src = fetchurl { url = builtins.replaceStrings [ "community" ] [ "community-jvm" ] g.src.url; hash = ({ "24.2.2" = "sha256-LDuMh4hhJSbKb8m5DSH8/tcb8rxiRG6FKS5okcUn2JY="; }).${g.version}; }; buildInputs = g.buildInputs ++ stable.graalvmPackages.graalvm-ce.buildInputs; }; # https://discourse.nixos.org/t/36314
  graalvmPackages.graalvm-ce.overlay = g: throwIf (hasInfix "font" g.preFixup) "graalvm-ce no longer requires an overlay" { preFixup = g.preFixup + "\nfind \"$out\" -name libfontmanager.so -exec patchelf --add-needed libfontconfig.so {} \\;"; }; # Workaround for https://github.com/NixOS/nixpkgs/pull/215583#issuecomment-1615369844
  htop.patch = ./library/assets/htop_colors.patch; # htop-dev/htop#1416
  inkscape = { patch = ./library/assets/inkscape_png-no-comment.patch; ccache = true; dontEval = true /* FIXME: infinite recursion */; }; # Pending inkscape/inkscape!7193
  inkscape-extensions.applytransforms = { overlay = a: recursiveUpdate a { meta.broken = versionAtLeast (findFirst (p: p ? pname && p.pname == "libxml2") null (findFirst (p: p.pname == "lxml") null (findFirst (p: p.pname == "inkex") null a.nativeCheckInputs).passthru.dependencies).nativeBuildInputs).version "2.15"; }; search = pin "55d3fa58ff9642d799d7489a7f8b0c218723fe07" "sha256-YzAIb9sYIujKmezFvAsyi6bXjqBWfcm3XY5kvQ3GDjM="; }; # Workaround for inkscape/extensions#617 (https://hydra.nixos.org/build/314374425)
  ios-safari-remote-debug-kit = any;
  ios-webkit-debug-proxy = any;
  iosevka-custom = any;
  iptables_exporter = any;
  jj-dynamic-default-description = any;
  josm = { jre = resolved.graalvmPackages.graalvm-ce; extraJavaOpts = "--module-path=${resolved.graalvmPackages.graaljs}/modules"; }; # josm-scripting-plugin
  josm-imagery-used = any;
  jujutsu.version = "≥0.36";
  just-local = any;
  kitty.patch = ./library/assets/kitty_paperwm.patch; # Workaround for paperwm/PaperWM#943
  little-a-map = any;
  losslesscut-bin.args = [ "--disable-networking" ];
  mark-applier = any;
  may-upgrade = any;
  meshtastic-url = any;
  minemap = any;
  mozjpeg-simple = any;
  nbt-explorer = any;
  nix-preview = any;
  nom-wrappers = any;
  off = any;
  oxvg = any;
  pdfalyzer = any;
  picard.overlay = p: { preFixup = p.preFixup + "\nmakeWrapperArgs+=(--prefix PATH : ${makeBinPath [ resolved.rsgain ]})"; }; # NixOS/nixpkgs#255222
  pngquant-interactive = any;
  pythonPackages.busylight-core.patch = ./library/assets/busylight-core_led-mask.patch;
  pythonPackages.busylight-for-humans.patch = ./library/assets/busylight-for-humans_fix-speed.patch; # Pending ≥0.45.3
  signal-desktop.args = [ "--use-tray-icon" ];
  snitch = any;
  spf-check = any;
  spf-tree = any;
  starship-jj = any;
  stretch-break = any;
  tile-stitch = any;
  unln = any;
  vscode-extensions = namespaced {
    andrewkvalheim.monokai-achromatic-gray = any;
    bpruitt-goddard.mermaid-markdown-syntax-highlighting.search = open-vsx;
    compilouit.xkb.search = open-vsx;
    csstools.postcss.search = open-vsx;
    earshinov.permute-lines.search = open-vsx;
    earshinov.simple-alignment.search = open-vsx;
    eseom.nunjucks-template.search = open-vsx;
    exiasr.hadolint.search = open-vsx;
    fabiospampinato.vscode-highlight.search = open-vsx;
    flowtype.flow-for-vscode = { version = "≥2.2.1"; search = [ open-vsx vscode-marketplace ]; };
    jjk.jjk.search = open-vsx;
    jnbt.vscode-rufo.search = open-vsx;
    joaompinto.vscode-graphviz.search = open-vsx;
    kokakiwi.vscode-just.search = open-vsx;
    leighlondon.eml.search = [ open-vsx vscode-marketplace ];
    loriscro.super.search = open-vsx;
    mitchdenny.ecdc.search = open-vsx;
    ms-vscode.wasm-wasi-core.search = open-vsx;
    ronnidc.nunjucks.search = [ open-vsx vscode-marketplace ];
    silvenon.mdx.search = open-vsx;
    sissel.shopify-liquid.search = open-vsx;
    syler.sass-indented.search = open-vsx;
    sysoev.language-stylus.search = open-vsx;
    theaflowers.qalc.search = open-vsx;
    volkerdobler.insertnums.search = open-vsx;
    webfreak.advanced-local-formatters.search = open-vsx;
    ybaumes.highlight-trailing-white-spaces.search = open-vsx;
  };
  whipper.patch = [ ./library/assets/whipper_flac-level.patch ./library/assets/whipper_speed.patch ./library/assets/whipper_detect-tty.patch ];
  wireguard-vanity-address = any;
  ydotool.patch = ./library/assets/ydotool-engramish.patch; # Pending ReimuNotMoe/ydotool#177
  yubikey-touch-detector.overlay = y: {
    postPatch = y.postPatch or "" + ''substituteInPlace notifier/libnotify.go --replace-fail \
      'AppIcon: "yubikey-touch-detector"' \
      'AppIcon: "'"$out"'/share/icons/hicolor/128x128/apps/yubikey-touch-detector.png"'
    '';
  };
  zsh-abbr.condition = z: !z.meta.unfree;
  zsh-click = any;
}
