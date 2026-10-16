#!/bin/bash
# Script de informe técnico de Instagram
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")
PERFIL="https://instagram.com/virginiavaschetto?igsh=zndqaxbrmjvnv2vu"
ARCHIVO="informe_${FECHA}.txt"

echo "=== INFORME TECNICO INSTAGRAM ===" > $ARCHIVO
echo "Fecha y hora: $(date)" >> $ARCHIVO
echo "Perfil analizado: $PERFIL" >> $ARCHIVO
echo "" >> $ARCHIVO

echo "--- Cabeceras HTTP ---" >> $ARCHIVO
curl -I "$PERFIL" >> $ARCHIVO 2>&1
echo "" >> $ARCHIVO

echo "--- WHOIS del dominio ---" >> $ARCHIVO
whois instagram.com >> $ARCHIVO 2>&1
echo "" >> $ARCHIVO

echo "--- Traceroute hacia Instagram ---" >> $ARCHIVO
traceroute instagram.com >> $ARCHIVO 2>&1
echo "" >> $ARCHIVO

echo "Informe guardado en: $ARCHIVO"
#!/data/data/com.termux/files/usr/bin/bash
# Informe técnico automático de Instagram

# Fecha y hora actual
fecha=$(date +"%Y-%m-%d_%H-%M-%S")

# Carpeta de informes
mkdir -p ~/informes_instagram

# Archivo de salida
archivo=~/informes_instagram/informe_$fecha.txt

# Encabezado del informe
echo "=== INFORME TÉCNICO INSTAGRAM ===" > $archivo
echo "Fecha: $(date)" >> $archivo
echo "---------------------------------" >> $archivo

# Cabeceras HTTP
echo "[1] Cabeceras HTTP" >> $archivo
curl -I "https://instagram.com/virginiavaschetto?igsh=zndqaxbrmjvnv2vu" >> $archivo 2>&1
echo "---------------------------------" >> $archivo

# Whois del dominio
echo "[2] WHOIS del dominio instagram.com" >> $archivo
whois instagram.com >> $archivo 2>&1
echo "---------------------------------" >> $archivo

# Traceroute hacia Instagram
echo "[3] Traceroute hacia instagram.com" >> $archivo
traceroute instagram.com >> $archivo 2>&1
echo "---------------------------------" >> $archivo

# Final del informe
echo "Informe generado correctamente en: $archivo"
#!/data/data/com.termux/files/usr/bin/bash
# Informe técnico automático de Instagram

# Fecha y hora actual
fecha=$(date +"%Y-%m-%d_%H-%M-%S")

# Carpeta de informes
mkdir -p ~/informes_instagram

# Archivo de salida
archivo=~/informes_instagram/informe_$fecha.txt

# Encabezado del informe
echo "=== INFORME TÉCNICO INSTAGRAM ===" > $archivo
echo "Fecha: $(date)" >> $archivo
echo "---------------------------------" >> $archivo

# Cabeceras HTTP
echo "[1] Cabeceras HTTP" >> $archivo
curl -I "https://instagram.com/virginiavaschetto?igsh=zndqaxbrmjvnv2vu" >> $archivo 2>&1
echo "---------------------------------" >> $archivo

# Whois del dominio
echo "[2] WHOIS del dominio instagram.com" >> $archivo
whois instagram.com >> $archivo 2>&1
echo "---------------------------------" >> $archivo

# Traceroute hacia Instagram
echo "[3] Traceroute hacia instagram.com" >> $archivo
traceroute instagram.com >> $archivo 2>&1
echo "---------------------------------" >> $archivo

# Final del informe
echo "Informe generado correctamente en: $archivo"
