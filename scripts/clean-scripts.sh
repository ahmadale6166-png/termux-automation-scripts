#!/data/data/com.termux/files/usr/bin/bash
# Limpieza de scripts rotos en Termux

LOGFILE="$HOME/clean-scripts.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "[+] Inicio de limpieza: $(date)"

# Carpeta principal
cd $HOME

# Lista de scripts que fallaron previamente (ajustá según tus pruebas)
BROKEN_SCRIPTS=(
  "analizador_ambiental.sh"
  "auditar.sh"
  "auditor_licencias.sh"
  "auto_actualizar.sh"
  "automatizar.sh"
  "escudo_fantasma.sh"
  "ia_autonoma.sh"
  "monitor.sh"
  "monitoreo_red.sh"
  "optimizar.sh"
  "radar_honeypot.sh"
  "radar_wifi.sh"
  "scanner_libs.sh"
  "servicios.sh"
  "test_vulkan.sh"
)

echo "[+] Moviendo scripts rotos a carpeta backup..."
mkdir -p $HOME/scripts_backup
for script in "${BROKEN_SCRIPTS[@]}"; do
  if [ -f "$HOME/$script" ]; then
    mv "$HOME/$script" "$HOME/scripts_backup/"
    echo "   -> $script movido a backup"
  fi
done

echo "[+] Fin de limpieza: $(date)"
echo "[+] Log guardado en $LOGFILE"
