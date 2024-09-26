# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage
# mode:
# - null: Default mode
# - "ci": from Garnix CI
# - "nur": from NUR bot
# - "legacy": from legacyPackages
mode:
{
  pkgs ? import <nixpkgs> { },
  ...
}:
let
  inherit (pkgs) lib;

  ifNotCI = p: if mode == "ci" then null else p;

  ifNotNUR = p: if mode == "nur" then null else p;

  nvfetcherLoader = pkgs.callPackage ../helpers/nvfetcher-loader.nix { };

  mkScope =
    f:
    builtins.removeAttrs
      (lib.makeScope pkgs.newScope (
        self:
        let
          pkg = self.newScope rec {
            inherit mkScope nvfetcherLoader;
            sources = nvfetcherLoader ../_sources/generated.nix;
          };
        in
        f self pkg
      ))
      [
        "newScope"
        "callPackage"
        "overrideScope"
        "overrideScope'"
        "packages"
      ];
in
mkScope (
  self: pkg:
  let
    # Wrapper will greatly increase NUR evaluation time. Disable on NUR to stay within 15s time limit.
    mergePkgs = self.callPackage ../helpers/merge-pkgs.nix {
      enableWrapper =
        !(builtins.elem mode [
          "nur"
          "legacy"
        ]);
    };

    meta = import ../helpers/meta.nix;
  in
  {
    # Binary cache information
    _meta = mergePkgs (
      {
        howto = pkg ./_meta/howto { };
        readme = pkg ./_meta/readme { };
      }
      // meta
    );

    # Package groups
    asteriskDigiumCodecs = mergePkgs (pkg ./asterisk-digium-codecs { inherit mergePkgs; });

    lantianCustomized = mergePkgs {
      # Packages with significant customization by Lan Tian
      asterisk = pkg ./lantian-customized/asterisk { };
      attic-telnyx-compatible = ifNotNUR (pkg ./lantian-customized/attic-telnyx-compatible { });
      coredns = pkg ./lantian-customized/coredns { };
      firefox-icon-mikozilla-fireyae = pkg ./lantian-customized/firefox-icon-mikozilla-fireyae { };
      librime-with-plugins = pkg ./lantian-customized/librime-with-plugins { };
      llama-cpp = pkg ./lantian-customized/llama-cpp { };
      nbfc-linux = pkg ./lantian-customized/nbfc-linux { };
      nginx = pkg ./lantian-customized/nginx { };
      transmission-with-webui = pkg ./lantian-customized/transmission-with-webui { };
    };

    lantianLinuxXanmod = mergePkgs (pkg ./lantian-linux-xanmod { inherit mode; });
    lantianLinuxXanmodPackages = ifNotCI (
      mergePkgs (pkg ./lantian-linux-xanmod/packages.nix { inherit mode; })
    );

    lantianPersonal = ifNotCI (mergePkgs {
      # Personal packages with no intention to be used by others
      libltnginx = pkg ./lantian-personal/libltnginx { };
    });

    nvidia-grid = ifNotCI (mergePkgs (pkg ./nvidia-grid { inherit mergePkgs; }));
    openj9-ibm-semeru = ifNotCI (mergePkgs (pkg ./openj9-ibm-semeru { }));
    openjdk-adoptium = ifNotCI (mergePkgs (pkg ./openjdk-adoptium { }));
    plangothic-fonts = mergePkgs (pkg ./plangothic-fonts { });
    th-fonts = mergePkgs (pkg ./th-fonts { });

    # Kernel modules
    kernel = pkgs.linux;
    acpi-ec = pkg ./kernel-modules/acpi-ec { };
    ast = pkg ./kernel-modules/ast { };
    cryptodev-unstable = pkg ./kernel-modules/cryptodev-unstable { };
    dpdk-kmod = pkg ./kernel-modules/dpdk-kmod { };
    i915-sriov = pkg ./kernel-modules/i915-sriov { };
    nft-fullcone = pkg ./kernel-modules/nft-fullcone { };
    nullfsvfs = pkg ./kernel-modules/nullfsvfs { };
    ovpn-dco = pkg ./kernel-modules/ovpn-dco { };
    r8125 = pkg ./kernel-modules/r8125 { };
    r8168 = pkg ./kernel-modules/r8168 { };

    # Other packages
    amule-dlp = pkg ./uncategorized/amule-dlp { };
    asterisk-g72x = pkg ./uncategorized/asterisk-g72x { };
    axiom-syslog-proxy = pkg ./uncategorized/axiom-syslog-proxy { };
    baidunetdisk = pkg ./uncategorized/baidunetdisk { };
    baidupcs-go = pkg ./uncategorized/baidupcs-go { };
    bepasty = pkg ./uncategorized/bepasty { };
    bilibili = pkg ./uncategorized/bilibili { };
    bird-lg-go = pkg ./uncategorized/bird-lg-go { };
    bird-lgproxy-go = pkg ./uncategorized/bird-lgproxy-go { };
    boringssl-oqs = pkg ./uncategorized/boringssl-oqs { };
    browser360 = pkg ./uncategorized/browser360 { };
    calibre-cops = pkg ./uncategorized/calibre-cops { };
    chmlib-utils = pkg ./uncategorized/chmlib-utils { };
    click-loglevel = pkg ./uncategorized/click-loglevel { };
    cloudpan189-go = pkg ./uncategorized/cloudpan189-go { };
    cockpy = pkg ./uncategorized/cockpy { };
    decluttarr = pkg ./uncategorized/decluttarr { };
    deepspeech-gpu = ifNotCI (pkg ./uncategorized/deepspeech-gpu { });
    deepspeech-wrappers = ifNotCI (pkg ./uncategorized/deepspeech-gpu/wrappers.nix { });
    dingtalk = pkg ./uncategorized/dingtalk { };
    dn42-pingfinder = pkg ./uncategorized/dn42-pingfinder { };
    douban-openapi-server = pkg ./uncategorized/douban-openapi-server { };
    drone-file-secret = pkg ./uncategorized/drone-file-secret { };
    drone-vault = pkg ./uncategorized/drone-vault { };
    electron_11 = pkg ./uncategorized/electron_11 { };
    etherguard = pkg ./uncategorized/etherguard { };
    fastapi-dls = pkg ./uncategorized/fastapi-dls { };
    fcitx5-breeze = pkg ./uncategorized/fcitx5-breeze { };
    flasgger = pkg ./uncategorized/flasgger { };
    ftp-proxy = pkg ./uncategorized/ftp-proxy { };
    genshin-checkin-helper = pkg ./uncategorized/genshin-checkin-helper { };
    genshinhelper2 = pkg ./uncategorized/genshinhelper2 { };
    glauth = pkg ./uncategorized/glauth { };
    google-earth-pro = pkg ./uncategorized/google-earth-pro { };
    gopherus = pkg ./uncategorized/gopherus { };
    grasscutter = pkg ./uncategorized/grasscutter { };
    hath = pkg ./uncategorized/hath { };
    helium-gateway-rs = pkg ./uncategorized/helium-gateway-rs { };
    hesuvi-hrir = pkg ./uncategorized/hesuvi-hrir { };
    hi3-ii-martian-font = pkg ./uncategorized/hi3-ii-martian-font { };
    hoyo-glyphs = pkg ./uncategorized/hoyo-glyphs { };
    imewlconverter = pkg ./uncategorized/imewlconverter { };
    inter-knot = pkg ./uncategorized/inter-knot { };
    jproxy = pkg ./uncategorized/jproxy { };
    kaixinsong-fonts = pkg ./uncategorized/kaixinsong-fonts { };
    kata-image = pkg ./uncategorized/kata-image { };
    kata-runtime = pkg ./uncategorized/kata-runtime { };
    kikoplay = pkg ./uncategorized/kikoplay { };
    konnect = pkg ./uncategorized/konnect { };
    ldap-auth-proxy = pkg ./uncategorized/ldap-auth-proxy { };
    libnftnl-fullcone = pkg ./uncategorized/libnftnl-fullcone { };
    liboqs = pkg ./uncategorized/liboqs { };
    liboqs-unstable = pkg ./uncategorized/liboqs/unstable.nix { };
    lyrica = pkg ./uncategorized/lyrica { };
    lyrica-plasmoid = pkg ./uncategorized/lyrica-plasmoid { };
    magiskboot = pkg ./uncategorized/magiskboot { };
    mtkclient = pkg ./uncategorized/mtkclient { };
    ncmdump-rs = pkg ./uncategorized/ncmdump-rs { };
    netboot-xyz = pkg ./uncategorized/netboot-xyz { };
    netease-cloud-music = pkg ./uncategorized/netease-cloud-music { };
    netns-exec = pkg ./uncategorized/netns-exec { };
    nftables-fullcone = pkg ./uncategorized/nftables-fullcone { };
    noise-suppression-for-voice = pkg ./uncategorized/noise-suppression-for-voice { };
    nullfs = pkg ./uncategorized/nullfs { };
    nvlax = pkg ./uncategorized/nvlax { };
    nvlax-530 = pkg ./uncategorized/nvlax/nvidia-530.nix { };
    oci-arm-host-capacity = pkg ./uncategorized/oci-arm-host-capacity { };
    onepush = pkg ./uncategorized/onepush { };
    openssl-oqs = pkg ./uncategorized/openssl-oqs { inherit (pkgs.linuxPackages) cryptodev; };
    openssl-oqs-provider = pkg ./uncategorized/openssl-oqs-provider { };
    openvswitch-dpdk = pkg ./uncategorized/openvswitch-dpdk { };
    osdlyrics = pkg ./uncategorized/osdlyrics { };
    palworld-exporter = pkg ./uncategorized/palworld-exporter { };
    palworld-worldoptions = pkg ./uncategorized/palworld-worldoptions { };
    payload-dumper-go = pkg ./uncategorized/payload-dumper-go { };
    peerbanhelper = pkg ./uncategorized/peerbanhelper { };
    phpmyadmin = pkg ./uncategorized/phpmyadmin { };
    phppgadmin = pkg ./uncategorized/phppgadmin { };
    plasma-panel-transparency-toggle = pkg ./uncategorized/plasma-panel-transparency-toggle { };
    plasma-smart-video-wallpaper-reborn = pkg ./uncategorized/plasma-smart-video-wallpaper-reborn { };
    pocl = pkg ./uncategorized/pocl { };
    procps4 = pkg ./uncategorized/procps4 { };
    pterodactyl-wings = pkg ./uncategorized/pterodactyl-wings { };
    py-rcon = pkg ./uncategorized/py-rcon { };
    qbittorrent-enhanced-edition = pkg ./uncategorized/qbittorrent-enhanced-edition { };
    qbittorrent-enhanced-edition-nox = pkg ./uncategorized/qbittorrent-enhanced-edition/nox.nix { };
    libqcef = pkg ./uncategorized/libqcef { };
    qemu-user-static = pkg ./uncategorized/qemu-user-static { };
    qhttpengine = pkg ./uncategorized/qhttpengine { };
    qq = pkg ./uncategorized/qq { };
    qqmusic = pkg ./uncategorized/qqmusic { };
    rime-aurora-pinyin = pkg ./uncategorized/rime-aurora-pinyin { };
    rime-custom-pinyin-dictionary = pkg ./uncategorized/rime-custom-pinyin-dictionary { };
    rime-dict = pkg ./uncategorized/rime-dict { };
    rime-ice = pkg ./uncategorized/rime-ice { };
    rime-moegirl = pkg ./uncategorized/rime-moegirl { };
    rime-zhwiki = pkg ./uncategorized/rime-zhwiki { };
    route-chain = pkg ./uncategorized/route-chain { };
    runpod-python = pkg ./uncategorized/runpod-python { };
    runpodctl = pkg ./uncategorized/runpodctl { };
    sam-toki-mouse-cursors = pkg ./uncategorized/sam-toki-mouse-cursors { };
    sgx-software-enable = pkg ./uncategorized/sgx-software-enable { };
    smartrent_py = pkg ./uncategorized/smartrent_py { };
    smfc = pkg ./uncategorized/smfc { };
    soggy = pkg ./uncategorized/soggy { };
    space-cadet-pinball-full-tilt = pkg ./uncategorized/space-cadet-pinball-full-tilt { };
    svp = pkg ./uncategorized/svp { };
    svp-mpv = pkg ./uncategorized/svp/mpv.nix { };
    sx1302-hal = pkg ./uncategorized/sx1302-hal { };
    suwayomi-server = pkg ./uncategorized/suwayomi-server { };
    tqdm-loggable = pkg ./uncategorized/tqdm-loggable { };
    uesave = pkg ./uncategorized/uesave { };
    uesave-0_3_0 = pkg ./uncategorized/uesave/0_3_0.nix { };
    uksmd = pkg ./uncategorized/uksmd { };
    vbmeta-disable-verification = pkg ./uncategorized/vbmeta-disable-verification { };
    vgpu-unlock-rs = pkg ./uncategorized/vgpu-unlock-rs { };
    vpp = pkg ./uncategorized/vpp { };
    wechat-uos = pkg ./uncategorized/wechat-uos {
      sources = nvfetcherLoader ../_sources/generated.nix;
    };
    wechat-uos-without-sandbox = pkg ./uncategorized/wechat-uos {
      sources = nvfetcherLoader ../_sources/generated.nix;
      enableSandbox = false;
    };

    # Deprecated alias
    wechat-uos-bin = self.wechat-uos;

    wine-wechat = lib.makeOverridable pkg ./uncategorized/wine-wechat { };
    wine-wechat-x86 = lib.makeOverridable pkg ./uncategorized/wine-wechat-x86 { };
    xstatic-asciinema-player = pkg ./uncategorized/xstatic-asciinema-player { };
    xstatic-font-awesome = pkg ./uncategorized/xstatic-font-awesome { };
  }
)
