# La soberanía no se terceriza

Charla Reveal.js (Org → HTML) para la Insurgencia en la Datosfera, RedDAG, 31 de octubre de 2026.

Repositorio: <https://github.com/ehshackleton/present-reddag>
Sitio: <http://sgodoy.sdf.org/>

Teclas: `s` notas · `Esc` mapa · `C` anotar · `B` pizarra. Flecha derecha = relato de 20 minutos; flecha abajo = reserva.

## Docker Compose

```bash
docker compose up --build
```

Abre <http://127.0.0.1:8080/>. La imagen Nginx sirve `index.html`, CSS, `vendor/`, iconos, QR y el video.

## Ver sin Docker

```bash
python3 -m http.server 8765
```

Abre <http://127.0.0.1:8765/> (usa `index.html`; no abras el archivo con `file://`).

## Regenerar el HTML

Hace falta Emacs con `ox-reveal` (en este equipo: Doom, `~/.emacs.d/.local/straight/build-29.4`).

```bash
./exportar-reveal.sh
```

Eso escribe `Presentacion_Soberania_Reveal.html` y lo copia a `index.html`.

Desde Emacs, en `Presentacion_Soberania_Reveal.org`: `C-c C-e h h` (al abrir el archivo, acepta las variables locales con `!`).

Iconos (Simple Icons CC0 + Shields MIT/Apache-2.0): `./scripts/descargar-iconos.sh`. Detalle en [`assets/LICENCIAS.md`](assets/LICENCIAS.md).

## Subir a SDF

En SDF el sitio del usuario suele ser `~/html/`. Desde este directorio:

```bash
rsync -av --exclude .git \
  --exclude emacs --exclude scripts --exclude '*.org' \
  --exclude exportar-reveal.sh --exclude README.md --exclude .gitignore \
  --exclude Dockerfile --exclude compose.yaml --exclude nginx.conf \
  --exclude .dockerignore --exclude LICENSE \
  ./ sgodoy@sdf.org:html/
```

`index.html` es la charla en la raíz de <http://sgodoy.sdf.org/>.

## Licencias

El texto de la charla (Org, HTML, CSS, scripts de export y el video) está bajo [CC BY-SA 4.0](LICENSE). Copyright 2026 Sebastián Godoy Olivares.

Material de terceros (no se relicencia):

- Reveal.js y plugins en `vendor/reveal.js/`: MIT. Ver [`vendor/reveal.js/LICENSE`](vendor/reveal.js/LICENSE).
- Fuentes del tema black: ver los `LICENSE` junto a las fuentes.
- Iconos SVG en `assets/simple-icons/`: [Simple Icons](https://github.com/simple-icons/simple-icons), CC0 1.0.
- Badges en `assets/shields/`: [Shields](https://github.com/badges/shields), MIT / Apache-2.0.

Las marcas (GNU, Linux, Firefox, etc.) siguen siendo de sus titulares. Uso nominativo, sin implicar respaldo. Detalle en [`assets/LICENCIAS.md`](assets/LICENCIAS.md).
