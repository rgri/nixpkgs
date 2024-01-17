{ lib
, php
, mkDerivation
, fetchurl
, makeWrapper
}:
let
  php' = php.withExtensions ({ enabled, all }: enabled ++ [ all.ast ]);
in
mkDerivation rec {
  pname = "phan";
  version = "5.4.3";

  src = fetchurl {
    url = "https://github.com/phan/phan/releases/download/${version}/phan.phar";
    hash = "sha256-wZU6YIlH0q18iD044y6Z5gSscBn7cI0AwRwZgT/YhOo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phan/phan.phar
    makeWrapper ${php'}/bin/php $out/bin/phan \
      --add-flags "$out/libexec/phan/phan.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Static analyzer for PHP";
    longDescription = ''
      Phan is a static analyzer for PHP. Phan prefers to avoid false-positives
      and attempts to prove incorrectness rather than correctness.
    '';
    license = licenses.mit;
    homepage = "https://github.com/phan/phan";
    maintainers = [ maintainers.apeschar ];
  };
}
