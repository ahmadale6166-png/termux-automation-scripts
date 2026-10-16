#!/bin/bash
# Script para validar y buscar evidencia OSINT de nombres y apellidos
# Guarda resultados en ~/evidencia_osint

nombre="$*"
carpeta=~/evidencia_osint
mkdir -p "$carpeta"

timestamp=$(date +"%Y%m%d_%H%M%S")
archivo="$carpeta/evidencia_nombre_${timestamp}.txt"

echo "[+] Buscando evidencia para: $nombre" | tee -a "$archivo"

# Maigret (si está instalado)
if command -v maigret >/dev/null 2>&1; then
    echo "🔎 Ejecutando Maigret..." | tee -a "$archivo"
    maigret "$nombre" --json | tee -a "$archivo"
fi

# Scylla (si está instalado)
if command -v scylla >/dev/null 2>&1; then
    echo "🔎 Ejecutando Scylla..." | tee -a "$archivo"
    scylla -q "$nombre" | tee -a "$archivo"
fi

# Google dorking básico
echo "🔎 Búsqueda en Google (manual): https://www.google.com/search?q=\"$nombre\"" | tee -a "$archivo"

echo "[✔] Evidencia guardada en $archivo"
