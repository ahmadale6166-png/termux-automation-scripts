#!/data/data/com.termux/files/usr/bin/bash

LOG_FILE="$HOME/lab_startup.log"
echo "--- Inicio de log: $(date) ---" > "$LOG_FILE"

echo "=========================================="
echo "    INICIANDO LABORATORIO DVWA EN TERMUX  "
echo "=========================================="

MARIADB_DIR="$HOME/mariadb"
DATA_DIR="$MARIADB_DIR/data"
RUN_DIR="$MARIADB_DIR/run"
SOCKET_PATH="$RUN_DIR/mysql.sock"
PID_PATH="$RUN_DIR/mysql.pid"

mkdir -p "$DATA_DIR" "$RUN_DIR"

if [ ! -d "$DATA_DIR/mysql" ]; then
    echo "[*] Inicializando base de datos en $DATA_DIR..."
    mysql_install_db --datadir="$DATA_DIR" >> "$LOG_FILE" 2>&1
fi

if pgrep -f "mariadbd|mysqld" > /dev/null; then
    echo "[+] MariaDB ya está en ejecución."
else
    echo "[*] Arrancando MariaDB con socket local..."
    mariadbd-safe --datadir="$DATA_DIR" --socket="$SOCKET_PATH" --pid-file="$PID_PATH" >> "$LOG_FILE" 2>&1 &
    sleep 3
fi

# Detectar directorio DVWA
DVWA_PATH=""
[ -d "$HOME/DVWA" ] && DVWA_PATH="$HOME/DVWA"
[ -d "$HOME/dvwa" ] && DVWA_PATH="$HOME/dvwa"

if [ -z "$DVWA_PATH" ]; then
    echo "[-] ERROR: No se encontró la carpeta DVWA en ~/DVWA ni ~/dvwa"
    exit 1
fi

# Reiniciar servidor PHP
pkill -f "php -d sys_temp_dir=$HOME/tmp -S 127.0.0.1:8080" 2>/dev/null
echo "[*] Arrancando servidor PHP para DVWA..."
cd "$DVWA_PATH" && php -d sys_temp_dir=$HOME/tmp -S 127.0.0.1:8080 >> "$LOG_FILE" 2>&1 &
sleep 2

if pgrep -f "php -d sys_temp_dir=$HOME/tmp -S 127.0.0.1:8080" > /dev/null; then
    echo "[+] Servidor PHP activo en http://127.0.0.1:8080"
else
    echo "[-] ERROR: PHP no pudo iniciar. Revisa $LOG_FILE"
fi

echo "=========================================="
