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
      rev = "36495";
      ignoreExternals = true;
      hash = "sha256-lvYOrcL8D+SA1MVsmQc1eV/KnQ4V1RrHolmFGV9XyYc=";
    };

    srcJosmTools = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/tools/";
      rev = josm.version;
      ignoreExternals = true;
      hash = {
        "19439" = "sha256-tFGq0YD/vmkRb26tXIlkKzAWaMf6GrwEGm7l81uGkHw=";
        "19481" = "sha256-tFGq0YD/vmkRb26tXIlkKzAWaMf6GrwEGm7l81uGkHw=";
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
        @@ -123 +123 @@
        -    <target name="compile" depends="init, pre-compile, resolve-tools, plugin-classpath-actual" unless="skip-compile">
        +    <target name="compile" depends="init, pre-compile, plugin-classpath-actual" unless="skip-compile">
        @@ -126 +125,0 @@
        -            <path refid="errorprone_javac.classpath"/>
        @@ -146 +144,0 @@
        -            <compilerarg pathref="errorprone.classpath"/>
        @@ -149 +146,0 @@
        -            <compilerarg value="-Xplugin:ErrorProne -Xep:StringSplitter:OFF -Xep:ReferenceEquality:OFF -Xep:InsecureCryptoUsage:OFF -Xep:FutureReturnValueIgnored:OFF -Xep:JdkObsolete:OFF -Xep:EqualsHashCode:OFF -Xep:JavaUtilDate:OFF -Xep:DoNotCallSuggester:OFF -Xep:BanSerializableRead:OFF" />
      '')
    ];

    nativeBuildInputs = [ ant jdk ];

    buildPhase = ''
      env --chdir josm/plugins/${pluginName} ant
    '';

    installPhase = ''
      install -D -t $out/share/JOSM/plugins /build/josm/dist/${pluginName}.jar
    '';
  };
}
