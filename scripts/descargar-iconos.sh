#!/usr/bin/env bash
# Descarga Simple Icons (CC0) y badges Shields (MIT/Apache-2.0) para uso offline.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SI="$ROOT/assets/simple-icons"
SH="$ROOT/assets/shields"
mkdir -p "$SI" "$SH"

SI_CDN="https://cdn.jsdelivr.net/npm/simple-icons/icons"
SH_SVG="https://img.shields.io/badge"
SH_PNG="https://raster.shields.io/badge"

download() {
  local url="$1" dest="$2"
  echo "  $dest"
  curl -fsSL --retry 3 --retry-delay 1 -A "present-reddag/1.0" "$url" -o "$dest"
  if [[ ! -s "$dest" ]]; then
    echo "vacío: $url" >&2
    rm -f "$dest"
    return 1
  fi
}

echo "== Simple Icons (SVG) =="
slugs=(
  gnu linux git firefoxbrowser torbrowser libreoffice
  vlcmediaplayer gimp inkscape thunderbird gnuemacs
  github opensourceinitiative debian
  fedora ubuntu linuxmint archlinux freebsd openbsd
  lineageos fdroid kde osmand organicmaps antennapod
  onlyoffice zotero joplin nextcloud calibre
  python r julia jupyter matplotlib qgis kicad freecad
  openscad blender krita mypaint scribus penpot
  audacity obsstudio musescore mixxx mpv
  kdenlive shotcut ardour lmms
  mastodon pleroma lemmy pixelfed peertube matrix element
  jitsi mumble friendica
  nginx apache caddy openssl wireguard openvpn
  postgresql mariadb sqlite docker podman kubernetes
  gitea php rust go gcc wordpress drupal
  godotengine minetest
)
for slug in "${slugs[@]}"; do
  download "$SI_CDN/${slug}.svg" "$SI/${slug}.svg" || echo "WARN: falta $slug" >&2
done

# name | shields path after /badge/ | query (logo etc)
echo "== Shields SVG + PNG =="
# shellcheck disable=SC2034
badges=(
  "gnu|GNU-A42E2B|logo=gnu&logoColor=white"
  "linux|Linux-FCC624|logo=linux&logoColor=black"
  "git|Git-F05032|logo=git&logoColor=white"
  "github|GitHub-181717|logo=github&logoColor=white"
  "osi|Open_Source-3DA639|logo=opensourceinitiative&logoColor=white"
  "derechos|Derechos-usar_estudiar_compartir-ed64a6|"
  "capacidades|Capacidades-operar_en_comunidad-42affa|"
  "infraestructura|Infraestructura-poder_irse-18a303|"
  "gratis|Gratis-precio-6c6c6c|"
  "libre|Libre-derecho-A42E2B|logo=gnu&logoColor=white"
  "f0|F0-Ejecutar-ed64a6|"
  "f1|F1-Estudiar-42affa|"
  "f2|F2-Compartir-18a303|"
  "f3|F3-Mejorar-FCC624|"
  "mit|licencia-MIT-yellow|"
  "gnu1983|1983-GNU-A42E2B|logo=gnu&logoColor=white"
  "fsf|1985-FSF-42affa|"
  "gpl|1989-GPL-ed64a6|logo=gnu&logoColor=white"
  "linux1991|1991-Linux-FCC624|logo=linux&logoColor=black"
  "copyleft|copyleft-las_libertades_viajan-A42E2B|"
  "gnulinux|GNU/Linux-A42E2B|logo=linux&logoColor=white"
  "debian|Debian-A81D33|logo=debian&logoColor=white"
  "firefox|Firefox-FF7139|logo=firefoxbrowser&logoColor=white"
  "tor|Tor_Browser-7D4698|logo=torbrowser&logoColor=white"
  "libreoffice|LibreOffice-18A303|logo=libreoffice&logoColor=white"
  "vlc|VLC-E85E00|logo=vlcmediaplayer&logoColor=white"
  "gimp|GIMP-5C5543|logo=gimp&logoColor=white"
  "inkscape|Inkscape-000000|logo=inkscape&logoColor=white"
  "thunderbird|Thunderbird-0A84FF|logo=thunderbird&logoColor=white"
  "gnuemacs|Emacs-7F5AB6|logo=gnuemacs&logoColor=white"
  "navegar|Navegar-Firefox_+_Tor-FF7139|logo=firefoxbrowser&logoColor=white"
  "escribir|Escribir-LibreOffice-18A303|logo=libreoffice&logoColor=white"
  "video|Video-VLC-E85E00|logo=vlcmediaplayer&logoColor=white"
  "imagen|Imagen-GIMP_+_Inkscape-5C5543|logo=gimp&logoColor=white"
  "correo|Correo-Thunderbird-0A84FF|logo=thunderbird&logoColor=white"
  "sistema|Sistema-GNU/Linux-A42E2B|logo=linux&logoColor=white"
  "definicion|Definición-GNU-A42E2B|logo=gnu&logoColor=white"
  "catalogo|Catálogo-directory.fsf.org-3DA639|logo=opensourceinitiative&logoColor=white"
  "matriz|Matriz-Collection:Windows-42affa|"
  "switching|switching.software-guía-ed64a6|"
  "auditar|Auditar-reglas_claras-ed64a6|"
  "portabilidad|Portabilidad-llevarse_los_datos-42affa|"
  "reproducibilidad|Reproducibilidad-otra_persona_repite-18a303|"
  "alfabetizacion|Alfabetización-aprender_a_operar-FCC624|"
  "gobernanza|Gobernanza-decisiones_visibles-7F5AB6|"
)

ok=0
fail=0
for spec in "${badges[@]}"; do
  IFS='|' read -r name path extra <<<"$spec"
  q="style=for-the-badge"
  if [[ -n "${extra}" ]]; then
    q="${q}&${extra}"
  fi
  url_svg="${SH_SVG}/${path}?${q}"
  url_png="${SH_PNG}/${path}?${q}"
  if download "$url_svg" "$SH/${name}.svg"; then
    ok=$((ok + 1))
  else
    # reintento sin logo
    if download "${SH_SVG}/${path}?style=for-the-badge" "$SH/${name}.svg"; then
      ok=$((ok + 1))
    else
      fail=$((fail + 1))
      continue
    fi
  fi
  download "$url_png" "$SH/${name}.png" || download "${SH_PNG}/${path}?style=for-the-badge" "$SH/${name}.png" || true
done

echo
echo "Listo. Simple Icons: $(ls -1 "$SI" | wc -l | tr -d ' ')  Shields: $(ls -1 "$SH"/*.svg 2>/dev/null | wc -l | tr -d ' ') SVG  fallos=$fail"
