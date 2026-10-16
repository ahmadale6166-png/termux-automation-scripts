#!/bin/bash

# Configuración
PORTS=(9090 2222 3306) # Puertos libres que vas a monitorear
LOGFILE="honeypot.log"

echo "Iniciando Honeypot en los puertos: ${PORTS[@]}"
echo "Registrando IPs, fecha y hora en $LOGFILE..."

# Función para registrar datos con IP, fecha y hora
log_conexion() {
    local port="$1"
    local ip=$(echo $2 | awk '{print $1}')
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$datetime] Conexión en el puerto $port desde IP $ip" >> $LOGFILE
}

# Para cada puerto, iniciamos un honeypot
for PORT in "${PORTS[@]}"; do
    (while true; do
        # Escuchar en el puerto y registrar datos cuando alguien se conecte
        nc -l -p $PORT -c 'log_conexion '"$PORT"
    done) &
done

wait  # Para que el script siga corriendo indefinidamente
