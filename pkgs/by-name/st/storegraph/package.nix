{ lib, nix-du, graphviz, writeShellScriptBin, bash }:
let
  pname = "storegraph";
  nixdu = "${nix-du}/bin/nix-du";
  dot = "${graphviz}/bin/dot";
in writeShellScriptBin pname ''
  #!${bash}/bin/bash
    rm store.dot &> /dev/null
    rm store.svg &> /dev/null
    ${nixdu} > store.dot
    ${dot} -Tsvg store.dot -o store.svg
    rm store.dot &> /dev/null
''
