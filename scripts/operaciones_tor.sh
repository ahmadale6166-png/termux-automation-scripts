#!/bin/bash

# --- CONFIGURACIÓN ---
PROXY="--socks5-hostname localhost:9050"
LOG_FILE="inteligencia_fraude.log"

clear
echo "=================================================="
echo "    LABORATORIO DE INTELIGENCIA Y CONTRA-FRAUDE   "
echo "=================================================="

# Verificar si Tor está respondiendo en el puerto local
echo "[*] Validando pasarela de anonimato Tor..."
IP_TOR=$(curl -s $PROXY -4 ifconfig.me)

if [ -z "$IP_TOR" ]; then
    echo -e "\n[-] ERROR CRÍTICO: El proxy Tor no responde en el puerto 9050."
    echo "[!] Operación cancelada para evitar fuga de IP real."
    exit 1
fi

echo "[+] Conexión segura establecida."
echo "[+] IP del Nodo de Salida Tor: $IP_TOR"
echo "--------------------------------------------------"

# Función para registrar eventos de auditoría
registrar_evidencia() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# --- EJEMPLO DE INTERROGACIÓN DE PERFIL SOSPECHOSO ---
# Cuando investigues una cuenta, volcás su ID o Token acá
TOKEN_SOSPECHOSO="INSERTE_TOKEN_O_ID_A_EVALUAR"

echo "[*] Extrayendo metadatos del objetivo..."
# Se usa el proxy y se guarda la respuesta en bruto
RESPUESTA=$(curl -s $PROXY -X GET "https://graph.facebook.com/v19.0/me?fields=id,name,security_settings&access_token=${TOKEN_SOSPECHOSO}")

# Analizar la estructura en busca de patrones automatizados o cuentas bot
if echo "$RESPUESTA" | grep -q "error"; then
    echo "[-] Servidor remoto denegó el acceso (Token expirado/falso)."
    registrar_evidencia "Fallo de verificación en objetivo: Token Invalido."
else
    echo "[+] Datos del perfil sospechoso capturados con éxito."
    echo "$RESPUESTA" | jq .
    registrar_evidencia "Datos extraídos con éxito del ID: $(echo "$RESPUESTA" | jq -r '.id')"
fi
echo "=================================================="
