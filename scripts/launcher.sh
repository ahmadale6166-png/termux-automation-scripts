#!/data/data/com.termux/files/usr/bin/bash
# Launcher interactivo con opción de ejecutar todos los scripts OK

OKDIR="$HOME/scripts_ok"
LOGFILE="$HOME/launcher.log"

echo "=== Launcher de Scripts OK ==="
echo "Selecciona un script para ejecutar:"
echo

i=1
declare -A scripts
for script in "$OKDIR"/*.sh; do
  [ -f "$script" ] || continue
  scripts[$i]="$script"
  echo " [$i] $(basename "$script")"
  i=$((i+1))
done

if [ $i -eq 1 ]; then
  echo "[!] No hay scripts en $OKDIR"
  exit 1
fi

echo " [A] Ejecutar TODOS los scripts OK"
echo
read -p "Número de script o 'A': " choice

if [ "$choice" = "A" ]; then
  echo "[+] Ejecutando todos los scripts con timeout de 10s..."
  for s in "$OKDIR"/*.sh; do
    [ -f "$s" ] || continue
    echo "   -> $(basename "$s")"
    timeout 10 bash "$s" | tee -a "$LOGFILE"
    if [ $? -eq 124 ]; then
      echo "   [!] $(basename "$s") se quedó colgado y fue detenido."
    fi
  done
elif [ -n "${scripts[$choice]}" ]; then
  selected="${scripts[$choice]}"
  echo "[+] Ejecutando $(basename "$selected") con timeout de 10s..."
  timeout 10 bash "$selected" | tee -a "$LOGFILE"
  if [ $? -eq 124 ]; then
    echo "[!] El script se quedó colgado y fue detenido por timeout."
  fi
else
  echo "[!] Opción inválida."
fi

echo "[+] Log guardado en $LOGFILE"
#!/data/data/com.termux/files/usr/bin/bash
# Launcher interactivo con opción de ejecutar todos y resumen

OKDIR="$HOME/scripts_ok"
LOGFILE="$HOME/launcher.log"

echo "=== Launcher de Scripts OK ==="
echo "Selecciona un script para ejecutar:"
echo

i=1
declare -A scripts
for script in "$OKDIR"/*.sh; do
  [ -f "$script" ] || continue
  scripts[$i]="$script"
  echo " [$i] $(basename "$script")"
  i=$((i+1))
done

if [ $i -eq 1 ]; then
  echo "[!] No hay scripts en $OKDIR"
  exit 1
fi

echo " [A] Ejecutar TODOS los scripts OK"
echo
read -p "Número de script o 'A': " choice

ok_count=0
fail_count=0

run_script() {
  local s="$1"
  echo "   -> Ejecutando $(basename "$s")"
  timeout 10 bash "$s" | tee -a "$LOGFILE"
  if [ $? -eq 124 ]; then
    echo "   [!] $(basename "$s") se quedó colgado (timeout)."
    fail_count=$((fail_count+1))
  else
    echo "   [+] $(basename "$s") terminó correctamente."
    ok_count=$((ok_count+1))
  fi
}

if [ "$choice" = "A" ]; then
  echo "[+] Ejecutando todos los scripts con timeout de 10s..."
  for s in "$OKDIR"/*.sh; do
    [ -f "$s" ] || continue
    run_script "$s"
  done
elif [ -n "${scripts[$choice]}" ]; then
  run_script "${scripts[$choice]}"
else
  echo "[!] Opción inválida."
fi

echo
echo "=== 📊 Resumen de ejecución ==="
echo "   Scripts OK: $ok_count"
echo "   Scripts fallidos/timeout: $fail_count"
echo "[+] Log guardado en $LOGFILE"
#!/data/data/com.termux/files/usr/bin/bash
# Launcher interactivo con opción de ejecutar todos y resumen detallado

OKDIR="$HOME/scripts_ok"
LOGFILE="$HOME/launcher.log"

echo "=== Launcher de Scripts OK ==="
echo "Selecciona un script para ejecutar:"
echo

i=1
declare -A scripts
for script in "$OKDIR"/*.sh; do
  [ -f "$script" ] || continue
  scripts[$i]="$script"
  echo " [$i] $(basename "$script")"
  i=$((i+1))
done

if [ $i -eq 1 ]; then
  echo "[!] No hay scripts en $OKDIR"
  exit 1
fi

echo " [A] Ejecutar TODOS los scripts OK"
echo
read -p "Número de script o 'A': " choice

ok_count=0
fail_count=0
timeout_count=0

run_script() {
  local s="$1"
  echo "   -> Ejecutando $(basename "$s")"
  timeout 10 bash "$s" | tee -a "$LOGFILE"
  case $? in
    0)
      echo "   [+] $(basename "$s") terminó correctamente."
      ok_count=$((ok_count+1))
      ;;
    124)
      echo "   [!] $(basename "$s") se quedó colgado (timeout)."
      timeout_count=$((timeout_count+1))
      ;;
    *)
      echo "   [!] $(basename "$s") terminó con error."
      fail_count=$((fail_count+1))
      ;;
  esac
}

if [ "$choice" = "A" ]; then
  echo "[+] Ejecutando todos los scripts con timeout de 10s..."
  for s in "$OKDIR"/*.sh; do
    [ -f "$s" ] || continue
    run_script "$s"
  done
elif [ -n "${scripts[$choice]}" ]; then
  run_script "${scripts[$choice]}"
else
  echo "[!] Opción inválida."
fi

echo
echo "=== 📊 Resumen de ejecución ==="
echo "   Scripts OK: $ok_count"
echo "   Scripts con error: $fail_count"
echo "   Scripts detenidos por timeout: $timeout_count"
echo "[+] Log guardado en $LOGFILE"
