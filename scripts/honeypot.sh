#!/bin/bash

# Puertos libres para monitorear
PORTS=(4444 5555 8081)
LOGFILE="honeypot.log"

echo "Iniciando Honeypot en puertos: ${PORTS[@]}"
echo "Registrando en $LOGFILE..."

# Función para registrar conexiones con IP y hora
log_conexion() {
    local port="$1"
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$datetime] Conexión en el puerto $port" >> $LOGFILE
}

# Escuchar en cada puerto
for PORT in "${PORTS[@]}"; do
    (while true; do
        nc -l -p $PORT -c "log_conexion $PORT"
    done) &
done

wait
