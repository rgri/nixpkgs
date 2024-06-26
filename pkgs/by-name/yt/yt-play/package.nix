{ lib
, mplayer
, mpv
, yt-dlp
, bash
, writeShellScriptBin
 }:
let pname = "yt-play";
    in
writeShellScriptBin pname ''
#!${bash}/bin/bash

# ----------------------------------------------------------------------------
# ytplay: a command line program for displaying YouTube videos as ASCII output
# ----------------------------------------------------------------------------
# Dependencies:
# youtube-dl (https://github.com/ytdl-org/youtube-dl)
# mplayer
# mpv

CLEAR='\033[0m'
RED='\033[0;31m'

usage() {
  if [ -n "$1" ]; then
    echo -e "''${RED}👉 $1''${CLEAR}\n"
  fi

  cat << EOF
  Usage: $(basename "$0") [REQUIRED -u url] [options]
    -h, --help     Show this message
    -u, --url      (Required) URL
    --classic      Classic mode, which plays in black and white using aalib instead
    -c, --caca     Uses libcaca to display output instead

  Examples: $(basename "$0") --classic -u "https://www.youtube.com/watch?v=5qap5aO4i9A"
EOF
}

# parse params
while [[ "$#" -gt 0 ]]; do case $1 in
      -h|--help)   usage; exit 0 ;;
      -u|--url)    URL="$2"; shift; shift ;;
      --classic)   CLASSIC=1; shift ;;
      -c|--caca)   CACA=1; shift ;;
      *)           usage "Unknown parameter passed: $1"; exit 1 ;;
esac; done

if [ -z "$URL" ]; then
  usage "No URL specified"
  exit 1
fi

if [ -n "$CACA" ]; then
  # if caca is specified
  ${yt-dlp}/bin/yt-dlp "$URL"  -o - | ${mpv}/bin/mpv --vo=caca -
  exit 0
elif [ -n "$CLASSIC" ]; then
  # if classic is specified
  ${yt-dlp}/bin/yt-dlp "$URL"  -o - | ${mplayer}/bin/mplayer -vo aa -monitorpixelaspect 0.5 -
  exit 0
else
  # else, play the video inline directly in the terminal with colors
  until ${yt-dlp}/bin/yt-dlp --quiet --no-warnings "$URL"  -o - | ${mpv}/bin/mpv --vo=tct --really-quiet -
  do
    echo "Stream has stopped, restarting..."
    sleep 1
  done
  exit 0
fi
''
