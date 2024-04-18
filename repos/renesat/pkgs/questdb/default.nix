{ lib, fetchFromGitHub, jre, makeWrapper, maven, git, procps }:

maven.buildMavenPackage rec {
  pname = "questdb";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "questdb";
    repo = pname;
    rev = version;
    hash = "sha256-4sn8uhZAdRvp37Fy0k6DFmFVY8YHv9g/b5pkuaq5dW8=";
  };

  mvnParameters = "-DskipTests";

  buildOffline = true;

  mvnHash = "sha256-iX9Tz+iIE6LNM9bhfn0ju2JisRjpobt0zSt2wFAcAb0=";

  nativeBuildInputs = [ makeWrapper git ];

  installPhase = ''
    mkdir -p $out/bin $out/share/
    install -Dm644 core/target/questdb-${version}.jar $out/share/questdb/questdb.jar
    install -Dm644 core/src/main/bin/env.sh $out/share/questdb/env.sh
    install -Dm755 core/src/main/bin/questdb.sh $out/share/questdb/questdb.sh 
    makeWrapper $out/share/questdb/questdb.sh $out/bin/questdb
  '';

  meta = {
    description = "Simple command line wrapper around JD Core Java Decompiler project";
    homepage = "https://github.com/intoolswetrust/jd-cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ majiir ];
  };
}
