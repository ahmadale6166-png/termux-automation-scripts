#!/bin/bash

# Puertos muy altos para evitar conflictos
PORTS=(55000 55001 55002)
LOGFILE="honeypot_hunter.log"
JSONFILE="honeypot_hunter.json"

echo "Iniciando Honeypot con Hunter en puertos: ${PORTS[@]}"
echo "Registrando en $LOGFILE y $JSONFILE..."

log_conexion() {
    local port="$1"
    local ip="$2"
    local payload="$3"
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")

    # Log en texto
    echo "[$datetime] Conexión en puerto $port desde IP $ip" >> $LOGFILE
    echo "Payload recibido: $payload" >> $LOGFILE
    echo "----" >> $LOGFILE

    # Log en JSON
    echo "{\"datetime\":\"$datetime\",\"port\":\"$port\",\"ip\":\"$ip\",\"payload\":\"$payload\"}" >> $JSONFILE

    # Análisis con Hunter
    if [ ! -z "$ip" ]; then
        hunter --analyze "$ip" >> $LOGFILE
        echo "{\"datetime\":\"$datetime\",\"port\":\"$port\",\"ip\":\"$ip\",\"hunter\":\"analizado\"}" >> $JSONFILE
    fi
}

for PORT in "${PORTS[@]}"; do
    (while true; do
        PAYLOAD=$(nc -l -p $PORT -v)
        IP=$(echo "$PAYLOAD" | grep "connect" | awk '{print $3}')
        log_conexion "$PORT" "$IP" "$PAYLOAD"
    done) &
done

wait
