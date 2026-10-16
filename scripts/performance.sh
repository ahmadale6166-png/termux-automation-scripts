#!/data/data/com.termux/files/usr/bin/bash
# Script Performance Mode para Termux

echo "[+] Activando modo performance..."

# Governor en performance (requiere root)
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
  echo performance > $cpu/cpufreq/scaling_governor 2>/dev/null
done

# Afinidad de núcleos con taskset
echo "[+] Ejecutando stress-ng en todos los núcleos..."
taskset -c 0-3 stress-ng --cpu 4 --timeout 60s &

# Subir prioridad con renice
PID=$(pidof stress-ng)
if [ -n "$PID" ]; then
  renice -n -10 -p $PID
  echo "[+] Proceso stress-ng con prioridad máxima."
fi

# Monitoreo en tiempo real
echo "[+] Iniciando htop..."
htop
