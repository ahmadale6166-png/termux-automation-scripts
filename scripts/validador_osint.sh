#!/bin/bash
# Script para validar DNI, CUIL, CBU y Teléfono
# Integra PhoneInfoga y guarda evidencia en carpeta ~/evidencia_osint

dato="$1"
carpeta=~/evidencia_osint
mkdir -p "$carpeta"

timestamp=$(date +"%Y%m%d_%H%M%S")
archivo="$carpeta/evidencia_${timestamp}.txt"

echo "[+] Validando dato: $dato" | tee -a "$archivo"

# DNI (7 u 8 dígitos)
if echo "$dato" | grep -qE '^[0-9]{7,8}$'; then
    echo "✅ DNI válido (formato correcto)" | tee -a "$archivo"
    exit 0
fi

# CUIL (11 dígitos)
if echo "$dato" | grep -qE '^[0-9]{11}$'; then
    echo "✅ CUIL válido (formato correcto)" | tee -a "$archivo"
    exit 0
fi

# CBU (22 dígitos)
if echo "$dato" | grep -qE '^[0-9]{22}$'; then
    echo "✅ CBU válido (formato correcto)" | tee -a "$archivo"
    exit 0
fi

# Teléfono argentino (+549 seguido de 10 dígitos)
if echo "$dato" | grep -qE '^\+549[0-9]{10}$'; then
    echo "✅ Teléfono válido (formato correcto)" | tee -a "$archivo"
    echo "🔎 Ejecutando PhoneInfoga..." | tee -a "$archivo"
    cd ~/PhoneInfoga || exit
    python3 phoneinfoga.py scan -n "$dato" | tee -a "$archivo"
    exit 0
fi

echo "❌ Formato inválido o dato desconocido" | tee -a "$archivo"
