{
lib,
stdenv,
fetchurl,
appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "thorium-browser";
  version = "120.0.6099.235";

  src = fetchurl {
    url =
      "https://github.com/Alex313031/thorium/releases/download/M${version}/Thorium_Browser_${version}_x64.AppImage";
    hash = "sha256-HVqC0uk5Ia1xolLvCwDl42VXAUwkikqRasNdLOe8SUs=";
  };
  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      install -Dm444 ${contents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
      install -Dm444 ${contents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
    '';

  meta = with lib; {
    description = "Compiler-optimized Chromium fork";
    homepage = "https://thorium.rocks";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ rgri ];
    license = licenses.bsd3;
    platforms = ["x86_64-linux"];
    mainProgram = "thorium-browser";
  };
}
