#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo "    ARRANCANDO LABORATORIO DVWA (FIJADO)  "
echo "=========================================="

# 1. Asegurar directorios temporales de usuario
mkdir -p $HOME/tmp
export TMPDIR=$HOME/tmp
export PHP_TMPDIR=$HOME/tmp

# 2. Levantar MariaDB de fondo si no está corriendo
if ! pgrep -x "mysqld" > /dev/null; then
    echo "[*] Arrancando MariaDB..."
    mysqld_safe --datadir=$HOME/mariadb > /dev/null 2>&1 &
    sleep 3
else
    echo "[+] MariaDB ya se encuentra en ejecución."
fi

# 3. Lanzar el servidor PHP con el parche de persistencia
echo "[*] Iniciando servidor PHP en http://127.0.0.1:8080 ..."
php -d sys_temp_dir=$HOME/tmp -d opcache.enable=0 -S 127.0.0.1:8080 -t $HOME/DVWA/
