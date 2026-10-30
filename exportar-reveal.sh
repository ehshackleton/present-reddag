#!/usr/bin/env bash
# Exporta Presentacion_Soberania_Reveal.org con ox-reveal (no con ox-html).
# Uso: ./exportar-reveal.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
ORG="$ROOT/Presentacion_Soberania_Reveal.org"
DOOM_BUILD="${HOME}/.emacs.d/.local/straight/build-29.4"

if [[ ! -f "$ORG" ]]; then
  echo "No encuentro $ORG" >&2
  exit 1
fi

if [[ ! -d "$DOOM_BUILD/org" || ! -d "$DOOM_BUILD/ox-reveal" ]]; then
  echo "Falta Org/ox-reveal de Doom en $DOOM_BUILD" >&2
  echo "Instala ox-reveal o ajusta DOOM_BUILD en este script." >&2
  exit 1
fi

cd "$ROOT"
emacs --batch \
  -L "$DOOM_BUILD/org" \
  -L "$DOOM_BUILD/ox-reveal" \
  -l org -l ox-html -l ox-reveal \
  "$ORG" \
  -f org-reveal-export-to-html

cp -f "$ROOT/Presentacion_Soberania_Reveal.html" "$ROOT/index.html"

echo
echo "Listo: $ROOT/Presentacion_Soberania_Reveal.html"
echo "       $ROOT/index.html"
echo "Abrir con: python3 -m http.server 8765"
echo "           http://127.0.0.1:8765/"
echo "En este archivo, C-c C-e h h también llama a ox-reveal (ver emacs/ox-html-como-reveal.el)."
echo "No abras el HTML con file://; usa el servidor HTTP."
