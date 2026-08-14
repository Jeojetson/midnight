#!/bin/bash
set -e
cd "$(dirname "$0")"
PORT=8765
URL="http://localhost:${PORT}/index.html"

echo "After Hours Records"
echo "-------------------"
echo "Starting a local web server so live album art can load correctly."
echo "Open: $URL"
echo "Press Control-C in this window when you're done."
echo

if command -v python3 >/dev/null 2>&1; then
  (sleep 1; open "$URL") &
  exec python3 -m http.server "$PORT"
elif command -v ruby >/dev/null 2>&1; then
  (sleep 1; open "$URL") &
  exec ruby -run -e httpd . -p "$PORT"
elif command -v npx >/dev/null 2>&1; then
  (sleep 2; open "$URL") &
  exec npx --yes serve -l "$PORT" .
else
  echo "No local web server runtime was found. Deploy index.html to GitHub Pages instead."
  read -p "Press Enter to close..."
fi
