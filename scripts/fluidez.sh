#!/bin/bash
echo "Liberando caché..."
sync; echo 3 > /proc/sys/vm/drop_caches

echo "Cerrando procesos pesados..."
pkill -9 -f chrome
pkill -9 -f firefox

echo "Chequeando conexión..."
ping -c 3 google.com

echo "Listo. Sistema más liviano."
