{ lib, stdenv, fetchFromGitHub, gradle, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.34.2";
  pname = "komf";

  src = fetchFromGitHub {
    owner = "Snd-R";
    repo = "komf";
    rev = "${version}";
    hash = "sha256-loyrKFg0TMAHSaZ5kmvG0GUYjWQHpBd1t7GWg0m+Xqw=";
  };

  nativeBuildInputs = [ gradle makeWrapper ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-PprojVersion=${version}" "-Dorg.gradle.java.home=${jdk}" ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    mkdir -p $out/{bin,share/komf}
    cp build/libs/komf-1.0-SNAPSHOT-all.jar $out/share/komf

    makeWrapper ${jdk}/bin/java $out/bin/komf \
      --add-flags "-jar $out/share/komf/komf-1.0-SNAPSHOT-all.jar"
  '';

  meta.sourceProvenance = with lib.sourceTypes; [
    fromSource
    binaryBytecode # mitm cache
  ];
}
