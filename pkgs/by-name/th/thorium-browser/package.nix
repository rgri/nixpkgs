{ lib, stdenv, fetchurl, appimageTools, }:

appimageTools.wrapType2 rec {
  pname = "thorium-browser";
  version = "122.0.6261.132";

  src = fetchurl {
    url =
      "https://github.com/Alex313031/thorium/releases/download/M${version}/Thorium_Browser_${version}_x64.AppImage";
    hash = "sha256-P10CI4C6V9vkkCLHhj4FVw6qyrchCpmnO7yDgajJnF8=";
  };
  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      install -Dm444 ${contents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
      install -Dm444 ${contents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
      mv $out/bin/thorium-browser* $out/bin/thorium-browser
      substituteInPlace $out/share/applications/thorium-browser.desktop \
        --replace /usr/bin $out/bin \
        --replace StartupWMClass=thorium StartupWMClass=thorium-browser \
        --replace Icon=thorium Icon=$out/share/icons/hicolor/512x512/apps/thorium.png \
        --replace Exec=thorium Exec=$out/bin/thorium-browser
    '';

  meta = with lib; {
    description = "Compiler-optimized Chromium fork";
    homepage = "https://thorium.rocks";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ rgri ];
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "darwin" ];
    mainProgram = "thorium-browser";
  };
}
