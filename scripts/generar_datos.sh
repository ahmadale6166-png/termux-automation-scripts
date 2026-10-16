#!/data/data/com.termux/files/usr/bin/bash
# Generador de datos ficticios para pruebas

OUTFILE="$HOME/datos_limpios.csv"

echo "[+] Generando archivo de datos en $OUTFILE..."

cat > "$OUTFILE" <<EOF
id,ingreso,egreso,categoria
1,5000,2000,Salario
2,300,150,Transporte
3,1200,800,Alquiler
4,450,300,Comida
5,200,100,Servicios
6,700,400,Entretenimiento
EOF

echo "[+] Archivo creado con datos ficticios."
echo "[+] Contenido:"
cat "$OUTFILE"
