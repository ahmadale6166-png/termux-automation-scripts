#!/bin/bash

clear
echo -e "\033[1;36m====================================================="
echo "       SISTEMA DE AUDITORÍA INTERNA DE SEGURIDAD      "
echo -e "=====================================================\033[0m"
echo "[i] Modo seguro activo (Sin requerir privilegios Root)."
echo "[+] Monitoreando logs de trampas y procesos de usuario..."
echo "-----------------------------------------------------"

LOG_HONEYPOT="$HOME/registro_intrusos_honeypot.txt"
HISTORICO_DEFENSA="$HOME/historico_defensa.txt"

# Asegurar que existan los archivos
touch "$LOG_HONEYPOT" "$HISTORICO_DEFENSA"

# Guardar tamaño inicial del log del Honeypot
lineas_iniciales=$(wc -l < "$LOG_HONEYPOT")
PROCESOS_BASE=$(ps -A | awk '{print $4}' | sort -u)

while true; do
    echo -e "\033[1;30m[$(date '+%H:%M:%S')]\033[0m Inspeccionando registros locales..."

    # 1. Monitorear el Honeypot leyendo los cambios en su propio archivo de texto
    lineas_actuales=$(wc -l < "$LOG_HONEYPOT")
    if [ "$lineas_actuales" -gt "$lineas_iniciales" ]; then
        nuevos_eventos=$((lineas_actuales - lineas_iniciales))
        echo -e "\033[1;31m[¡ALERTA EVENTO!] El Honeypot detectó $nuevos_eventos nueva(s) conexión(es) sospechosa(s).\033[0m"
        tail -n "$nuevos_eventos" "$LOG_HONEYPOT"
        echo "$(date '+%d/%m/%Y %H:%M:%S') | DEFENSA | Alerta de Honeypot procesada." >> "$HISTORICO_DEFENSA"
        lineas_iniciales=$lineas_actuales
    fi

    # 2. Monitor de Procesos en espacio de usuario (Permitido por Android)
    procesos_actuales=$(ps -A | awk '{print $4}' | sort -u)
    nuevos_procesos=$(comm -13 <(echo "$PROCESOS_BASE") <(echo "$procesos_actuales") | grep -vE '(ps|awk|comm|sort|sleep|ss|grep|bash|wc|tail|cat)')

    if [ ! -z "$nuevos_procesos" ]; then
        echo -e "\033[1;33m[SISTEMA] Cambio en hilos de usuario: $nuevos_procesos\033[0m"
        PROCESOS_BASE="$procesos_actuales"
    fi

    echo -e "\033[1;32m[OK]\033[0m Entorno de usuario Termux estable."
    echo "-----------------------------------------------------"
    sleep 3
done
