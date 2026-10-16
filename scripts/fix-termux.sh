#!/data/data/com.termux/files/usr/bin/bash
# Script de recuperación para Termux

echo "[+] Matando procesos apt/dpkg..."
for pid in $(ps -aux | grep -E 'apt|dpkg' | awk '{print $2}'); do
  kill -9 $pid 2>/dev/null
done

echo "[+] Eliminando locks..."
rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock-frontend
rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock

echo "[+] Reconfigurando paquetes pendientes..."
dpkg --configure -a

echo "[+] Reparando dependencias rotas..."
apt --fix-broken install -y

echo "[+] Instalando módulo Perl URI::Escape..."
pkg install -y perl-uri

echo "[+] Actualizando sistema..."
pkg update -y && pkg upgrade -y

echo "[+] Verificación rápida..."
perl -MURI::Escape -e 'print uri_escape("hola mundo");'
echo -e "\n[+] Si ves 'hola%20mundo', todo quedó bien."
