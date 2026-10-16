#!/bin/bash

echo "=== 📊 MAYORES INGRESOS DETECTADOS (BASH) ==="
# Filtra las transferencias o ingresos, limpia comillas y ordena de mayor a menor numérico
grep -E "Ingreso|recibida" datos_limpios.csv | tr -d '"' | awk -F',' '{
    gsub(/\./, "", $4); gsub(/,/, ".", $4);
    print $1 " | " $2 " | $" $4
}' | sort -t'$' -k2 -rn | head -n 5

echo ""
echo "=== 📉 MAYORES EGRESOS DETECTADOS (BASH) ==="
# Filtra pagos, servicios o envíos, aislando los valores negativos más altos
grep -E "Pago|enviada" datos_limpios.csv | tr -d '"' | awk -F',' '{
    gsub(/\./, "", $4); gsub(/,/, ".", $4);
    print $1 " | " $2 " | $" $4
}' | sort -t'$' -k2 -n | head -n 5

