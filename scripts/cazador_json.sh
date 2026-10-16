#!/bin/bash

PORTS=(2222 4444 5555 8081)
LOGFILE="cazador_hacker.json"

echo "🚨 Iniciando Cazador de Hackers en puertos: ${PORTS[@]}"
echo "[" > $LOGFILE   # Inicio del array JSON

log_event() {
    local port="$1"
    local ip="$2"
    local payload="$3"
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")

    # Registro en formato JSON
    echo "  {" >> $LOGFILE
    echo "    \"datetime\": \"$datetime\"," >> $LOGFILE
    echo "    \"port\": \"$port\"," >> $LOGFILE
    echo "    \"ip\": \"$ip\"," >> $LOGFILE
    echo "    \"payload\": \"$(echo $payload | tr -d '\"')\"" >> $LOGFILE
    echo "  }," >> $LOGFILE
}

for PORT in "${PORTS[@]}"; do
    (while true; do
        PAYLOAD=$(nc -l -p $PORT -v)
        IP=$(echo "$PAYLOAD" | grep "connect" | awk '{print $3}')
        log_event "$PORT" "$IP" "$PAYLOAD"
    done) &
done

wait
echo "]" >> $LOGFILE   # Cierra el array JSON
#!/bin/bash

PORTS=(2222 4444 5555 8081)
LOGFILE="cazador_hacker.json"

echo "🚨 Iniciando Cazador de Hackers en puertos: ${PORTS[@]}"
echo "[" > $LOGFILE   # Inicio del array JSON

log_event() {
    local port="$1"
    local ip="$2"
    local payload="$3"
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")

    # Mostrar en pantalla con colores
    echo -e "\033[1;31m[$datetime]\033[0m Conexión en puerto \033[1;34m$port\033[0m desde IP \033[1;32m$ip\033[0m"
    echo -e "Payload: \033[0;33m$payload\033[0m"
    echo "-----------------------------------"

    # Guardar en JSON
    echo "  {" >> $LOGFILE
    echo "    \"datetime\": \"$datetime\"," >> $LOGFILE
    echo "    \"port\": \"$port\"," >> $LOGFILE
    echo "    \"ip\": \"$ip\"," >> $LOGFILE
    echo "    \"payload\": \"$(echo $payload | tr -d '\"')\"" >> $LOGFILE
    echo "  }," >> $LOGFILE
}

for PORT in "${PORTS[@]}"; do
    (while true; do
        PAYLOAD=$(nc -l -p $PORT -v)
        IP=$(echo "$PAYLOAD" | grep "connect" | awk '{print $3}')
        log_event "$PORT" "$IP" "$PAYLOAD"
    done) &
done

wait
echo "]" >> $LOGFILE   # Cierra el array JSON
#!/bin/bash

PORTS=(2222 4444 5555 8081)
LOGFILE="cazador_hacker.json"

declare -A ip_count
declare -A port_count
total_attempts=0

echo "🚨 Iniciando Cazador de Hackers en puertos: ${PORTS[@]}"
echo "[" > $LOGFILE   # Inicio del array JSON

log_event() {
    local port="$1"
    local ip="$2"
    local payload="$3"
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")

    # Actualizar contadores
    ((total_attempts++))
    ((ip_count["$ip"]++))
    ((port_count["$port"]++))

    # Mostrar evento en pantalla
    echo -e "\033[1;31m[$datetime]\033[0m Conexión en puerto \033[1;34m$port\033[0m desde IP \033[1;32m$ip\033[0m"
    echo -e "Payload: \033[0;33m$payload\033[0m"
    echo "-----------------------------------"

    # Mostrar panel dinámico
    echo -e "\033[1;36m📊 Panel en vivo:\033[0m"
    echo "Intentos totales: $total_attempts"
    echo "IPs únicas detectadas: ${#ip_count[@]}"
    echo "Puertos más atacados:"
    for p in "${!port_count[@]}"; do
        echo "  - Puerto $p: ${port_count[$p]} intentos"
    done
    echo "==================================="

    # Guardar en JSON
    echo "  {" >> $LOGFILE
    echo "    \"datetime\": \"$datetime\"," >> $LOGFILE
    echo "    \"port\": \"$port\"," >> $LOGFILE
    echo "    \"ip\": \"$ip\"," >> $LOGFILE
    echo "    \"payload\": \"$(echo $payload | tr -d '\"')\"" >> $LOGFILE
    echo "  }," >> $LOGFILE
}

for PORT in "${PORTS[@]}"; do
    (while true; do
        PAYLOAD=$(nc -l -p $PORT -v)
        IP=$(echo "$PAYLOAD" | grep "connect" | awk '{print $3}')
        log_event "$PORT" "$IP" "$PAYLOAD"
    done) &
done

wait
echo "]" >> $LOGFILE   # Cierra el array JSON
