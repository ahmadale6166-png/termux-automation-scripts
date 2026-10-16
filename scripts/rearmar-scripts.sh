#!/data/data/com.termux/files/usr/bin/bash
# Rearme automático de scripts en Termux

LOGFILE="$HOME/rearmar-scripts.log"
BACKUPDIR="$HOME/scripts_backup"
OKDIR="$HOME/scripts_ok"

mkdir -p "$BACKUPDIR" "$OKDIR"
exec > >(tee -a "$LOGFILE") 2>&1

echo "[+] Inicio de rearme: $(date)"

cd $HOME

# Detectar todos los .sh
for script in *.sh; do
  if [ -f "$script" ]; then
    echo "[*] Probando $script..."
    bash "$script" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "   -> $script falló, moviendo a backup"
      mv "$script" "$BACKUPDIR/"
    else
      echo "   -> $script funciona, copiando a scripts_ok"
      cp "$script" "$OKDIR/"
    fi
  fi
done

echo "[+] Fin de rearme: $(date)"
echo "[+] Scripts buenos en $OKDIR"
echo "[+] Scripts rotos en $BACKUPDIR"
echo "[+] Log guardado en $LOGFILE"
