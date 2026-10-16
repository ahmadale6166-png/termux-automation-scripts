#!/bin/bash

# Puertos que queremos monitorear
PORTS=(9090 2222 3306)
LOGFILE="honeypot.log"

echo "Iniciando Honeypot en los puertos: ${PORTS[@]}"
echo "Registrando en $LOGFILE..."

# Función para registrar la conexión
log_conexion() {
    local port="$1"
    local ip="$2"
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$datetime] Conexión en el puerto $port desde IP $ip" >> $LOGFILE
}

# Escuchar en cada puerto
for PORT in "${PORTS[@]}"; do
    (while true; do
        # Esperar una conexión, registrar y cerrar
        nc -l -p $PORT -c 'log_conexion "'$PORT'" "$SOCAT_PEERADDR"'
    done) &
done

# Mantener el script corriendo
wait
