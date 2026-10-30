# La soberanía no se terceriza

Charla Reveal.js (Org → HTML) para la Insurgencia en la Datosfera, RedDAG, 31 de octubre de 2026.

Sitio previsto: <http://sgodoyo.sdf.org/>

## Ver en local

```bash
python3 -m http.server 8765
```

Abre <http://127.0.0.1:8765/> (usa `index.html`; no abras el archivo con `file://`).

Teclas: `s` notas · `Esc` mapa · `C` anotar · `B` pizarra. Flecha derecha = relato de 20 minutos; flecha abajo = reserva.

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
  ./ USUARIO@sdf.org:html/
```

Sustituye `USUARIO` por la cuenta SDF. `index.html` es la charla en la raíz de <http://sgodoyo.sdf.org/>.
