{ pkgs }:
let
  inherit (pkgs) lib newScope recurseIntoAttrs libsForQt5 darwin;
in
lib.makeScope newScope (
  self: with self; {

    # VSCODE EXTENSIONS

    vscode-extensions = recurseIntoAttrs (callPackage ./vscode-extensions { });

    ### APPLICATIONS

    goldencheetah-bin = callPackage ./applications/goldencheetah/bin.nix { };
    klogg = libsForQt5.callPackage ./applications/misc/klogg { };
    klogg-bin = callPackage ./applications/misc/klogg/bin.nix { };
    synwrite-bin = callPackage ./applications/synwrite/bin.nix { };

    ### BUILD SUPPORT

    fetchfromgh = callPackage ./build-support/fetchfromgh { };
    fetchgdrive = callPackage ./build-support/fetchgdrive { };
    fetchwebarchive = callPackage ./build-support/fetchwebarchive { };
    fetchymaps = callPackage ./build-support/fetchymaps { };

    ### DARWIN

    amethyst-bin = callPackage ./darwin/amethyst/bin.nix { };
    cudatext-bin = callPackage ./darwin/cudatext/bin.nix { };
    finch = callPackage ./darwin/finch {
      buildGoModule = pkgs.buildGo120Module;
    };
    macpass-bin = callPackage ./darwin/macpass/bin.nix { };
    marta-bin = callPackage ./darwin/marta { };
    pinentry-touchid = callPackage ./darwin/pinentry-touchid {
      inherit (darwin.apple_sdk.frameworks) LocalAuthentication;
    };
    podman-desktop-bin = callPackage ./darwin/podman-desktop/bin.nix { };
    qutebrowser-bin = callPackage ./darwin/qutebrowser/bin.nix { };
    sloth-bin = callPackage ./darwin/sloth { };

    ### DATA

    dadako = callPackage ./data/dicts/dadako { };
    freedict = callPackage ./data/dicts/freedict { };
    huzheng = callPackage ./data/dicts/huzheng { };
    it-sanasto = callPackage ./data/dicts/it-sanasto { };
    komputeko = callPackage ./data/dicts/komputeko { };
    tatoeba = callPackage ./data/dicts/tatoeba { };
    wiktionary = callPackage ./data/dicts/wiktionary { };

    gpsmap64 = callPackage ./data/firmwares/gpsmap64 { };

    dem = callPackage ./data/maps/dem { };
    freizeitkarte-osm = callPackage ./data/maps/freizeitkarte-osm { };
    gpxsee-maps = callPackage ./data/maps/gpxsee-maps { };
    vlasenko-maps = callPackage ./data/maps/vlasenko-maps { };
    maptourist = callPackage ./data/maps/maptourist { };
    meridian = callPackage ./data/maps/meridian { };
    mtk-suomi = callPackage ./data/maps/mtk-suomi { };
    opentopomap = callPackage ./data/maps/opentopomap { };
    qmapshack-onlinemaps = callPackage ./data/maps/qmapshack-onlinemaps { };
    slazav-hr = callPackage ./data/maps/slazav/hr.nix { };
    slazav-podm = callPackage ./data/maps/slazav/podm.nix { };
    slazav-podm-bin = callPackage ./data/maps/slazav/podm-bin.nix { };
    uralla = callPackage ./data/maps/uralla { };
    usa-osm-topo-routable = callPackage ./data/maps/usa-osm-topo-routable { };

    gadm = callPackage ./data/misc/gadm { };
    poi = callPackage ./data/misc/poi { };

    osm-extracts = callPackage ./data/osm/osm-extracts { };
    overpassdb = callPackage ./data/osm/overpassdb { };
    routinodb = callPackage ./data/osm/routinodb { };

    goldendict-arc-dark-theme =
      callPackage ./data/themes/goldendict-themes/arc-dark-theme.nix { };
    goldendict-dark-theme =
      callPackage ./data/themes/goldendict-themes/dark-theme.nix { };
    qtpbfimageplugin-styles = callPackage ./data/themes/qtpbfimageplugin-styles { };

    ### DEVELOPMENT / LIBRARIES

    libshell = callPackage ./development/libraries/libshell { };
    microjson = callPackage ./development/libraries/microjson { };

    ### DEVELOPMENT / PERL MODULES

    perlPackages = (
      callPackage ./perl-packages.nix { }
    ) // pkgs.perlPackages // {
      recurseForDerivations = false;
    };

    ### DEVELOPMENT / PYTHON MODULES

    click-6-7 = callPackage ./development/python-modules/click { };
    contextily = callPackage ./development/python-modules/contextily { };
    curses-menu = callPackage ./development/python-modules/curses-menu { };
    earthpy = callPackage ./development/python-modules/earthpy { };
    geotiler = callPackage ./development/python-modules/geotiler { };
    gpxelevations = callPackage ./development/python-modules/gpxelevations { };
    jsonseq = callPackage ./development/python-modules/jsonseq { };
    large-image = callPackage ./development/python-modules/large-image { };
    large-image-source-gdal = (callPackage ./development/python-modules/large-image/sources.nix { }).source-gdal;
    lru-dict = callPackage ./development/python-modules/lru-dict { };
    modbus_tk = callPackage ./development/python-modules/modbus_tk { };
    portolan = callPackage ./development/python-modules/portolan { };
    pymbtiles = callPackage ./development/python-modules/pymbtiles { };
    s2sphere = callPackage ./development/python-modules/s2sphere { };
    xyzservices = callPackage ./development/python-modules/xyzservices { };

    ### EMBEDDED

    chdk = callPackage ./embedded/chdk { };
    embox-aarch64 = callPackage ./embedded/embox { arch = "aarch64"; };
    embox-arm = callPackage ./embedded/embox { arch = "arm"; };
    embox-ppc = callPackage ./embedded/embox { arch = "ppc"; };
    embox-riscv64 = callPackage ./embedded/embox { arch = "riscv64"; };
    embox-x86 = callPackage ./embedded/embox {
      stdenv = pkgs.gccMultiStdenv;
    };

    ### GARMIN

    basecamp = callPackage ./garmin/basecamp { };
    cgpsmapper = callPackage ./garmin/cgpsmapper { };
    garmin-uploader = callPackage ./garmin/garmin-uploader { };
    garminimg = libsForQt5.callPackage ./garmin/garminimg {
      proj = pkgs.proj_7;
    };
    gimgtools = callPackage ./garmin/gimgtools { };
    gmaptool = callPackage ./garmin/gmaptool { };
    imgdecode = callPackage ./garmin/imgdecode { };
    libgarmin = callPackage ./garmin/libgarmin {
      automake = pkgs.automake111x;
    };
    ocad2img = perlPackages.callPackage ./garmin/ocad2img {
      inherit cgpsmapper ocad2mp fetchwebarchive;
    };
    ocad2mp = callPackage ./garmin/ocad2mp { };
    openmtbmap = callPackage ./garmin/openmtbmap { };
    osm2mp = perlPackages.callPackage ./garmin/osm2mp {
      inherit (perlPackages) GeoOpenstreetmapParser MatchSimple MathPolygon MathPolygonTree TreeR;
    };
    sendmap20 = callPackage ./garmin/sendmap20 { };

    ### GEMINI

    agunua = callPackage ./gemini/agunua { };
    astronaut = callPackage ./gemini/astronaut { };
    comitium = callPackage ./gemini/comitium { };
    gemcert = callPackage ./gemini/gemcert { };
    gemgen = callPackage ./gemini/gemgen { };
    gemget = callPackage ./gemini/gemget { };
    gemini-ipfs-gateway = callPackage ./gemini/gemini-ipfs-gateway { };
    geminid = callPackage ./gemini/geminid { };
    gemreader = callPackage ./gemini/gemreader { };
    gemserv = callPackage ./gemini/gemserv {
      inherit (darwin.apple_sdk.frameworks) Security;
    };
    gloggery = callPackage ./gemini/gloggery { };
    gmi2html = callPackage ./gemini/gmi2html { };
    gmnhg = callPackage ./gemini/gmnhg { };
    gmnigit = callPackage ./gemini/gmnigit { };
    gplaces = callPackage ./gemini/gplaces { };
    gssg = callPackage ./gemini/gssg { };
    gurl = callPackage ./gemini/gurl { };
    kineto = callPackage ./gemini/kineto { };
    py-gmi2html = callPackage ./gemini/py-gmi2html { };
    qute-gemini = callPackage ./gemini/qute-gemini { };
    satellite = callPackage ./gemini/satellite { };
    shavit = callPackage ./gemini/shavit { };
    stagit-gemini-milotier = callPackage ./gemini/stagit-gemini/milotier.nix { };
    stagit-gemini-sloum = callPackage ./gemini/stagit-gemini/sloum.nix { };
    stargazer = callPackage ./gemini/stargazer {
      inherit (darwin.apple_sdk.frameworks) Security;
    };
    tom = callPackage ./gemini/tom { };

    ### GEOSPATIAL

    apispec-webframeworks = callPackage ./geospatial/apispec-webframeworks { };
    arcgis2geojson = callPackage ./geospatial/arcgis2geojson { };
    c2cwsgiutils = callPackage ./geospatial/c2cwsgiutils { };
    cogeo-mosaic = callPackage ./geospatial/cogeo-mosaic { };
    color-operations = callPackage ./geospatial/color-operations { };
    datamaps = callPackage ./geospatial/datamaps { };
    deegree = callPackage ./geospatial/deegree { };
    elevation = callPackage ./geospatial/elevation {
      click = click-6-7;
    };
    geojson-pydantic = callPackage ./geospatial/geojson-pydantic { };
    geowebcache = callPackage ./geospatial/geowebcache { };
    go-pmtiles = callPackage ./geospatial/go-pmtiles { };
    go-staticmaps = callPackage ./geospatial/go-staticmaps { };
    hecate = callPackage ./geospatial/hecate {
      inherit (darwin.apple_sdk.frameworks) Security;
    };
    localtileserver = callPackage ./geospatial/localtileserver { };
    mapsoft = callPackage ./geospatial/mapsoft { };
    mapsoft2 = callPackage ./geospatial/mapsoft/2.nix { };
    mbtiles2osmand = callPackage ./geospatial/mbtiles2osmand { };
    mbutiles = callPackage ./geospatial/mbutiles { };
    mobroute = callPackage ./geospatial/mobroute { };
    morecantile = callPackage ./geospatial/morecantile { };
    orbisgis-bin = callPackage ./geospatial/orbisgis/bin.nix { jre = pkgs.jre8; };
    ossim = callPackage ./geospatial/ossim { };
    pmtiles = callPackage ./geospatial/pmtiles { };
    pipfile = callPackage ./geospatial/pipfile { };
    polyvectorization = libsForQt5.callPackage ./geospatial/polyvectorization { };
    py-staticmaps = callPackage ./geospatial/py-staticmaps { };
    pysheds = callPackage ./geospatial/pysheds { };
    pystac = callPackage ./geospatial/pystac { };
    render_geojson = callPackage ./geospatial/render_geojson { };
    rio-cogeo = callPackage ./geospatial/rio-cogeo { };
    rio-color = callPackage ./geospatial/rio-color { };
    rio-mbtiles = callPackage ./geospatial/rio-mbtiles { };
    rio-mucho = callPackage ./geospatial/rio-mucho { };
    rio-stac = callPackage ./geospatial/rio-stac { };
    rio-tiler = callPackage ./geospatial/rio-tiler { };
    sasplanet-bin = callPackage ./geospatial/sasplanet/bin.nix { };
    scooby = callPackage ./geospatial/scooby { };
    server-thread = callPackage ./geospatial/server-thread { };
    starlette-cramjam = callPackage ./geospatial/starlette-cramjam { };
    supermercado = callPackage ./geospatial/supermercado { };
    tdh = callPackage ./geospatial/tdh { };
    terracotta = callPackage ./geospatial/terracotta { };
    tile-stitch = callPackage ./geospatial/tile-stitch { };
    tilesets-cli = callPackage ./geospatial/tilesets-cli { };
    tpkutils = callPackage ./geospatial/tpkutils { };
    vt2geojson = callPackage ./geospatial/vt2geojson { };
    titiler = callPackage ./geospatial/titiler { };
    tilecloud = callPackage ./geospatial/tilecloud { };

    ### GNSS

    gps-sdr-sim = callPackage ./gnss/gps-sdr-sim { };
    gpstk = callPackage ./gnss/gpstk { };
    rtklib = callPackage ./gnss/rtklib { };
    visualgps = libsForQt5.callPackage ./gnss/visualgps { };

    ### GPX

    cmpgpx = callPackage ./gpx/cmpgpx { };
    garta = callPackage ./gpx/garta { };
    geojson2dm = callPackage ./gpx/geojson2dm { };
    gps-whatsnew = callPackage ./gpx/gps-whatsnew { };
    gpx-animator = callPackage ./gpx/gpx-animator { };
    gpx-cmd-tools = callPackage ./gpx/gpx-cmd-tools { };
    gpx-converter = callPackage ./gpx/gpx-converter { };
    gpx-interpolate = callPackage ./gpx/gpx-interpolate { };
    gpx-layer = perlPackages.callPackage ./gpx/gpx-layer { };
    gpx2yaml = callPackage ./gpx/gpx2yaml { };
    gpxchart = callPackage ./gpx/gpxchart { };
    gpxeditor = callPackage ./gpx/gpxeditor { };
    gpxlib = callPackage ./gpx/gpxlib { };
    gpxtools = callPackage ./gpx/gpxtools { };
    gpxtrackposter = callPackage ./gpx/gpxtrackposter { };
    trackanimation = callPackage ./gpx/trackanimation { };

    ### IMAGES

    dockerImages = {
      agate = callPackage ./images/agate { };
      elevation_server = callPackage ./images/elevation_server { };
      git = callPackage ./images/git {
        git = pkgs.gitMinimal.override {
          perlSupport = false;
          nlsSupport = false;
        };
      };
      mbtileserver = callPackage ./images/mbtileserver { };
      quark = callPackage ./images/quark { };
      wekan = callPackage ./images/wekan { };
    };

    ### LINGUISTICS

    dict2rest = callPackage ./linguistics/dict2rest { };
    distance = callPackage ./linguistics/distance { };
    gdcv = callPackage ./linguistics/gdcv { };
    goldendict-bin = callPackage ./linguistics/goldendict/bin.nix { };
    gt-bash-client = callPackage ./linguistics/gt-bash-client { };
    gt4gd = callPackage ./linguistics/gt4gd { };
    hfst = callPackage ./linguistics/hfst { };
    i18n-editor-bin = callPackage ./linguistics/i18n-editor { jre = pkgs.jdk11; };
    lsdreader = callPackage ./linguistics/lsdreader { };
    mikatools = callPackage ./linguistics/mikatools { };
    odict = callPackage ./linguistics/odict { };
    python-hfst = callPackage ./linguistics/python-hfst { };
    pytorchtext = callPackage ./linguistics/pytorchtext { };
    redict = libsForQt5.callPackage ./linguistics/redict { };
    revtok = callPackage ./linguistics/revtok { };
    stardict-tools = callPackage ./linguistics/stardict-tools { };
    tatoebatools = callPackage ./linguistics/tatoebatools { };
    wikitextprocessor = callPackage ./linguistics/wikitextprocessor { };
    wiktextract = callPackage ./linguistics/wiktextract { };
    wiktfinnish = callPackage ./linguistics/wiktfinnish { };
    zdict = callPackage ./linguistics/zdict { };

    ### MISC

    aamath = callPackage ./misc/aamath { };
    apibackuper = callPackage ./misc/apibackuper { };
    arduinojson = callPackage ./misc/arduinojson { };
    ascii-dash = callPackage ./misc/ascii-dash { };
    blink = callPackage ./misc/blink { };
    btpd = callPackage ./misc/btpd { };
    bwh = callPackage ./misc/bwh {
      inherit (darwin.apple_sdk.frameworks) AppKit;
    };
    capture2text = libsForQt5.callPackage ./misc/capture2text { };
    cfiles = callPackage ./misc/cfiles { };
    cpr = callPackage ./misc/cpr { };
    csvquote = callPackage ./misc/csvquote { };
    csvtools = callPackage ./misc/csvtools { };
    didder = callPackage ./misc/didder { };
    dns-filter = callPackage ./misc/dns-filter { };
    docker-reg-tool = callPackage ./misc/docker-reg-tool { };
    docx2csv = callPackage ./misc/docx2csv { };
    finalcut = callPackage ./misc/finalcut { };
    gaiagpsclient = callPackage ./misc/gaiagpsclient { };
    glauth = callPackage ./misc/glauth { };
    graphene = callPackage ./misc/graphene { };
    gsl-lite = callPackage ./misc/gsl-lite { };
    how-to-use-pvs-studio-free = callPackage ./misc/pvs-studio/how-to-use-pvs-studio-free.nix { };
    huami-token = callPackage ./misc/huami-token { };
    ish = callPackage ./misc/ish { };
    jcli = callPackage ./misc/jcli { };
    lazyscraper = callPackage ./misc/lazyscraper { };
    libmdbx = callPackage ./misc/libmdbx { };
    libnbcompat = callPackage ./misc/libnbcompat { };
    md2html = callPackage ./misc/md2html { };
    miband4 = callPackage ./misc/miband4 { };
    modbus-tools = callPackage ./misc/modbus-tools {
      inherit (darwin.apple_sdk.frameworks) IOKit;
    };
    modbus_sim_cli = callPackage ./misc/modbus_sim_cli { };
    morse-talk = callPackage ./misc/morse-talk { };
    musig = callPackage ./misc/musig { };
    nanodns = callPackage ./misc/nanodns { };
    nmtree = callPackage ./misc/nmtree { };
    objlab = callPackage ./misc/objlab { };
    playonmac = callPackage ./misc/playonmac { };
    pnoise = callPackage ./misc/pnoise { };
    ptunnel = callPackage ./misc/ptunnel { };
    pvs-studio = callPackage ./misc/pvs-studio { };
    qasync = callPackage ./misc/qasync { };
    qoiview = callPackage ./misc/qoiview { };
    repolocli = callPackage ./misc/repolocli { };
    rst2txt = callPackage ./misc/rst2txt { };
    sdorfehs = callPackage ./misc/sdorfehs { };
    serverpp = callPackage ./misc/serverpp { };
    taskcoach = callPackage ./misc/taskcoach { };
    tcvt = callPackage ./misc/tcvt { };
    telegabber = callPackage ./misc/telegabber { };
    telnetpp = callPackage ./misc/telnetpp { };
    tinyflux = callPackage ./misc/tinyflux { };
    tlstunnel = callPackage ./misc/tlstunnel { };
    wik = callPackage ./misc/wik { };
    worm = callPackage ./misc/worm { };
    wptools = callPackage ./misc/wptools { };
    xfractint = callPackage ./misc/xfractint { };
    xtr = callPackage ./misc/xtr {
      inherit (darwin.apple_sdk.frameworks) Foundation;
    };

    ### MQTT

    emitter = callPackage ./mqtt/emitter { };
    flashmq = callPackage ./mqtt/flashmq { };
    go-mqtt-to-influxdb = callPackage ./mqtt/go-mqtt-to-influxdb { };
    influxdb-cxx = callPackage ./mqtt/influxdb-cxx { };
    janus-mqtt-proxy = callPackage ./mqtt/janus-mqtt-proxy { };
    mongoose = callPackage ./mqtt/mongoose { };
    mqtt-benchmark = callPackage ./mqtt/mqtt-benchmark { };
    mqtt-explorer = callPackage ./mqtt/mqtt-explorer { };
    mqtt-to-influxdb = callPackage ./mqtt/mqtt-to-influxdb { };
    mqtt-to-influxdb-forwarder = callPackage ./mqtt/mqtt-to-influxdb-forwarder { };
    rumqtt = callPackage ./mqtt/rumqtt {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    ### NAKARTE

    elevation_server = callPackage ./nakarte/elevation_server { };
    map-tiler = callPackage ./nakarte/map-tiler {
      python3Packages = pkgs.python39Packages;
    };
    maprec = callPackage ./nakarte/maprec {
      python3Packages = pkgs.python39Packages;
    };
    #nakarte = callPackage ./nakarte/nakarte { };
    ozi_map = callPackage ./nakarte/ozi_map {
      python3Packages = pkgs.python39Packages;
    };
    pyimagequant = callPackage ./nakarte/pyimagequant {
      python3Packages = pkgs.python39Packages;
    };
    thinplatespline = callPackage ./nakarte/thinplatespline {
      python3Packages = pkgs.python39Packages;
    };
    tracks_storage_server = callPackage ./nakarte/tracks_storage_server { };

    ### OSM

    cykhash = callPackage ./osm/cykhash { };
    imposm = callPackage ./osm/imposm { };
    map-machine = callPackage ./osm/map-machine { };
    map-stylizer = callPackage ./osm/map-stylizer { };
    maperitive-bin = callPackage ./osm/maperitive/bin.nix { };
    memphis = callPackage ./osm/memphis { };
    osm-3s = callPackage ./osm/osm-3s { };
    osm-area-tools = callPackage ./osm/osm-area-tools { };
    osm-python-tools = callPackage ./osm/osm-python-tools { };
    osm-tags-transform = callPackage ./osm/osm-tags-transform { };
    osm2geojson = callPackage ./osm/osm2geojson { };
    osmcoastline = callPackage ./osm/osmcoastline { };
    osmdbt = callPackage ./osm/osmdbt { };
    osmium-surplus = callPackage ./osm/osmium-surplus { };
    osmosis = callPackage ./osm/osmosis { };
    osmwalkthrough = callPackage ./osm/osmwalkthrough { };
    phyghtmap = callPackage ./osm/phyghtmap { };
    planetiler = callPackage ./osm/planetiler { };
    polytiles = callPackage ./osm/polytiles { };
    prettymapp = callPackage ./osm/prettymapp { };
    pyrobuf = callPackage ./osm/pyrobuf { };
    pyrosm = callPackage ./osm/pyrosm { };
    sdlmap = callPackage ./osm/sdlmap { };
    smopy = callPackage ./osm/smopy { };
    smrender = callPackage ./osm/smrender {
      inherit (darwin.apple_sdk.frameworks) Foundation;
    };
    taginfo-tools = callPackage ./osm/taginfo-tools { };
    tirex = callPackage ./osm/tirex { };
    vectiler = callPackage ./osm/vectiler { };

    ### RADIO

    aprsc = callPackage ./radio/aprsc { };
    fmreceiver = libsForQt5.callPackage ./radio/fmreceiver { };
    gqrx-scanner = callPackage ./radio/gqrx-scanner { };
    linrad = callPackage ./radio/linrad { };
    rtlsdr-airband = callPackage ./radio/rtlsdr-airband { };
    smallrx = callPackage ./radio/smallrx { };

    ### SUCKLESS

    amused = callPackage ./suckless/amused { };
    blind = callPackage ./suckless/blind { };
    chibicc = callPackage ./suckless/chibicc { };
    cproc = callPackage ./suckless/cproc { };
    dragon = callPackage ./suckless/dragon { };
    farbfeld-utils = callPackage ./suckless/farbfeld-utils { };
    ff-tools = callPackage ./suckless/ff-tools { };
    ffshot = callPackage ./suckless/ffshot { };
    hurl = callPackage ./suckless/hurl { };
    imscript = callPackage ./suckless/imscript { };
    imsg-compat = callPackage ./suckless/imsg-compat { };
    kilo = callPackage ./suckless/kilo { };
    lacc = callPackage ./suckless/lacc { };
    lbm = callPackage ./suckless/lbm { };
    lchat = callPackage ./suckless/lchat { };
    lel = callPackage ./suckless/lel { };
    libgrapheme = callPackage ./suckless/libgrapheme { };
    libst = callPackage ./suckless/libst { };
    libutf = callPackage ./suckless/libutf { };
    mage = callPackage ./suckless/mage { };
    makel = callPackage ./suckless/makel { };
    nextvi = callPackage ./suckless/nextvi { };
    pista = callPackage ./suckless/pista { };
    saait = callPackage ./suckless/saait { };
    sbase = callPackage ./suckless/sbase { };
    scc = callPackage ./suckless/scc { };
    scroll = callPackage ./suckless/scroll { };
    se = callPackage ./suckless/se { };
    sthkd = callPackage ./suckless/sthkd { };
    svtm = callPackage ./suckless/svtm { };
  }
)
