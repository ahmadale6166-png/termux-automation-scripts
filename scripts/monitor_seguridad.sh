#!/bin/bash

LOG_FILE="radar_ataques_sistema.log"

# Colores ANSI
RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${RED}====================================================${NC}"
echo -e "${RED}    MONITOR DE REGISTROS DEL SISTEMA Y ATAQUES     ${NC}"
echo -e "${RED}====================================================${NC}\n"

echo -e "${CYAN}[+] Archivo de guardado: ${YELLOW}$LOG_FILE${NC}"
echo -e "${GREEN}[+] Filtrando: Ejecución de procesos y eventos de seguridad...${NC}"
echo -e "${GREEN}[+] Presiona Ctrl + C para detener.${NC}\n"

# Limpiar buffer de logs anteriores
logcat -c 2>/dev/null

# Expresiones regulares para filtrar:
# 1. ATAQUES / AMENAZAS: Excepciones de seguridad, denegaciones SELinux, root, ADB no autorizado.
# 2. SISTEMA EN EJECUCIÓN: Procesos iniciando, servicios y apps abriéndose.
PATRON_ATAQUES="SecurityException|denied|Permission|unauthorized|SELinux|su|root|auth_failed|DROP|REJECT"
PATRON_SISTEMA="ActivityTaskManager|am_create_activity|START|Process|zygote"

# Ejecución y procesado en tiempo real
logcat -v time | grep -i --line-buffered -E "$PATRON_ATAQUES|$PATRON_SISTEMA" | while read -r line; do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # Detectar si es una alerta de seguridad/ataque
    if echo "$line" | grep -iqE "$PATRON_ATAQUES"; then
        ALERT_MSG="[ALERTA DE SEGURIDAD/AMENAZA] $line"
        echo -e "${RED}[!] $TIMESTAMP - $ALERT_MSG${NC}"
        echo "[$TIMESTAMP] $ALERT_MSG" >> "$LOG_FILE"

    # Detectar procesos/apps que se ejecutan
    elif echo "$line" | grep -iqE "$PATRON_SISTEMA"; then
        SYS_MSG="[SISTEMA/EJECUCIÓN] $line"
        echo -e "${CYAN}[+] $TIMESTAMP - $SYS_MSG${NC}"
        echo "[$TIMESTAMP] $SYS_MSG" >> "$LOG_FILE"
    fi
done
