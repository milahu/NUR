{ fetchsvn
, lib
, stdenv

  # Dependencies
, ant
, jdk
, josm
}:

# Modeled after https://josm.openstreetmap.de/wiki/DevelopersGuide/DevelopingPlugins
let
  inherit (builtins) toFile;
  inherit (lib) extendMkDerivation;
in
extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [ "pluginName" ];

  extendDrvArgs = _: { pluginName ? args.pname, ... } @ args: {
    srcJosmPlugins = fetchsvn {
      url = "https://josm.openstreetmap.de/osmsvn/applications/editors/josm/";
      rev = "36457";
      ignoreExternals = true;
      hash = "sha256-s70SZl1i5Wl9w/vMk+1DtPhffuXfm3YJnjI4RE1zn5I=";
    };

    srcJosmTools = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/tools/";
      rev = josm.version;
      ignoreExternals = true;
      hash = {
        "19369" = "sha256-tFGq0YD/vmkRb26tXIlkKzAWaMf6GrwEGm7l81uGkHw=";
        "19396" = "sha256-tFGq0YD/vmkRb26tXIlkKzAWaMf6GrwEGm7l81uGkHw=";
        "19412" = "sha256-tFGq0YD/vmkRb26tXIlkKzAWaMf6GrwEGm7l81uGkHw=";
        "19423" = "sha256-tFGq0YD/vmkRb26tXIlkKzAWaMf6GrwEGm7l81uGkHw=";
        "19439" = "sha256-tFGq0YD/vmkRb26tXIlkKzAWaMf6GrwEGm7l81uGkHw=";
      }."${josm.version}" or lib.fakeHash;
    };

    unpackPhase = ''
      cp --no-preserve=mode --recursive --reflink=auto $srcJosmPlugins josm
      mkdir josm/core && cp --no-preserve=mode --recursive --reflink=auto $srcJosmTools josm/core/tools
      mkdir josm/core/dist && ln --symbolic ${josm}/share/josm/josm.jar josm/core/dist/josm-custom.jar
      ln --symbolic josm/core/tools josm/plugins/00_core_tools
      cp --no-preserve=mode --recursive --reflink=auto $src josm/plugins/${pluginName}
    '';

    patches = [
      (toFile "offline.patch" ''
        --- a/josm/plugins/build-common.xml
        +++ b/josm/plugins/build-common.xml
        @@ -115 +115 @@
        -    <target name="compile" depends="init, pre-compile, resolve-tools" unless="skip-compile">
        +    <target name="compile" depends="init, pre-compile" unless="skip-compile">
        @@ -124 +123,0 @@
        -            <path refid="errorprone_javac.classpath"/>
        @@ -140 +138,0 @@
        -            <compilerarg pathref="errorprone.classpath"/>
        @@ -143 +140,0 @@
        -            <compilerarg value="-Xplugin:ErrorProne -Xep:StringSplitter:OFF -Xep:ReferenceEquality:OFF -Xep:InsecureCryptoUsage:OFF -Xep:FutureReturnValueIgnored:OFF -Xep:JdkObsolete:OFF -Xep:EqualsHashCode:OFF -Xep:JavaUtilDate:OFF -Xep:DoNotCallSuggester:OFF -Xep:BanSerializableRead:OFF" />
      '')
    ];

    nativeBuildInputs = [ ant jdk ];

    buildPhase = ''
      cd josm/plugins/${pluginName}
      ant
    '';

    installPhase = ''
      install -D -t $out/share/JOSM/plugins /build/josm/dist/${pluginName}.jar
    '';
  };
}
