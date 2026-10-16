#!/data/data/com.termux/files/usr/bin/bash
# Limpieza automática de scripts rotos en Termux

LOGFILE="$HOME/clean-auto.log"
BACKUPDIR="$HOME/scripts_backup"
mkdir -p "$BACKUPDIR"
exec > >(tee -a "$LOGFILE") 2>&1

echo "[+] Inicio de limpieza: $(date)"

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
      echo "   -> $script funciona correctamente"
    fi
  fi
done

echo "[+] Fin de limpieza: $(date)"
echo "[+] Scripts rotos movidos a $BACKUPDIR"
echo "[+] Log guardado en $LOGFILE"
