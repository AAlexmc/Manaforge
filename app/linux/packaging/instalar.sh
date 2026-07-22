#!/usr/bin/env bash
# Deja ManaForge en el menú de aplicaciones, con su icono.
#
# En Linux un programa suelto en una carpeta no aparece en ningún menú: hace
# falta un fichero .desktop y un icono en los sitios donde el escritorio los
# busca. Esto los pone SOLO para tu usuario (~/.local), así que no pide
# contraseña y no toca nada del sistema.
#
#   ./instalar.sh              instala
#   ./instalar.sh --desinstalar  quita lo instalado (la app y tus datos se quedan)
set -euo pipefail

AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS="$HOME/.local/share/applications"
ICONOS="$HOME/.local/share/icons/hicolor"
BIN="$HOME/.local/bin"
NOMBRE=manaforge

desinstalar() {
  rm -f "$APPS/$NOMBRE.desktop" "$BIN/$NOMBRE"
  for tam in 16 32 48 64 128 256 512; do
    rm -f "$ICONOS/${tam}x${tam}/apps/$NOMBRE.png"
  done
  command -v update-desktop-database >/dev/null && \
    update-desktop-database "$APPS" 2>/dev/null || true
  echo "Quitado del menú. La app sigue en $AQUI y tus cartas siguen donde estaban."
}

if [[ "${1:-}" == "--desinstalar" ]]; then
  desinstalar
  exit 0
fi

EJECUTABLE="$AQUI/$NOMBRE"
if [[ ! -x "$EJECUTABLE" ]]; then
  echo "No encuentro el ejecutable '$NOMBRE' junto a este script." >&2
  echo "Ejecuta instalar.sh desde la carpeta descomprimida." >&2
  exit 1
fi

mkdir -p "$APPS" "$BIN"
for tam in 16 32 48 64 128 256 512; do
  mkdir -p "$ICONOS/${tam}x${tam}/apps"
  install -m 644 "$AQUI/packaging/$NOMBRE-$tam.png" \
    "$ICONOS/${tam}x${tam}/apps/$NOMBRE.png"
done

# el .desktop lleva la ruta ABSOLUTA del ejecutable: la carpeta puede estar
# en cualquier sitio (Descargas, /opt, un disco externo)
sed "s|^Exec=.*|Exec=\"$EJECUTABLE\"|" "$AQUI/packaging/$NOMBRE.desktop" \
  > "$APPS/$NOMBRE.desktop"
chmod 644 "$APPS/$NOMBRE.desktop"

# y un enlace para poder escribir "manaforge" en la terminal
ln -sf "$EJECUTABLE" "$BIN/$NOMBRE"

command -v update-desktop-database >/dev/null && \
  update-desktop-database "$APPS" 2>/dev/null || true
command -v gtk-update-icon-cache >/dev/null && \
  gtk-update-icon-cache -f -t "$ICONOS" 2>/dev/null || true

echo "✓ ManaForge está en tu menú de aplicaciones."
echo "  Si no sale al momento, cierra y abre la sesión (el menú cachea)."
echo "  Para quitarlo: ./instalar.sh --desinstalar"
