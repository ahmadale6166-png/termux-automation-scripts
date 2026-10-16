#!/bin/bash
# Script OSINT unificado para validar DNI, CUIL, CBU, Teléfono y Nombres
# Guarda evidencia en ~/evidencia_osint

dato="$*"
carpeta=~/evidencia_osint
mkdir -p "$carpeta"

timestamp=$(date +"%Y%m%d_%H%M%S")
archivo="$carpeta/evidencia_${timestamp}.txt"

echo "[+] Analizando dato: $dato" | tee -a "$archivo"

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

# Nombres y apellidos (contienen letras y espacios)
if echo "$dato" | grep -qE '^[A-Za-zÁÉÍÓÚÑáéíóúñ ]+$'; then
    echo "✅ Nombre/Apellido detectado" | tee -a "$archivo"
    echo "🔎 Búsqueda OSINT manual: https://www.google.com/search?q=\"$dato\"" | tee -a "$archivo"
    echo "👉 Podés usar Maigret o Scylla para ampliar la búsqueda." | tee -a "$archivo"
    exit 0
fi

# Si no coincide con nada
echo "❌ Formato inválido o dato desconocido" | tee -a "$archivo"
#!/bin/bash
# Script OSINT unificado para DNI, CUIL, CBU, Teléfono, Nombres y Correos
# Guarda evidencia en ~/evidencia_osint

dato="$*"
carpeta=~/evidencia_osint
mkdir -p "$carpeta"

timestamp=$(date +"%Y%m%d_%H%M%S")
archivo="$carpeta/evidencia_${timestamp}.txt"

echo "[+] Analizando dato: $dato" | tee -a "$archivo"

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

# Correo electrónico
if echo "$dato" | grep -qE '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'; then
    echo "✅ Correo electrónico detectado" | tee -a "$archivo"
    if command -v holehe >/dev/null 2>&1; then
        echo "🔎 Ejecutando Holehe..." | tee -a "$archivo"
        holehe "$dato" | tee -a "$archivo"
    fi
    exit 0
fi

# Nombres y apellidos (letras y espacios)
if echo "$dato" | grep -qE '^[A-Za-zÁÉÍÓÚÑáéíóúñ ]+$'; then
    echo "✅ Nombre/Apellido detectado" | tee -a "$archivo"
    if command -v maigret >/dev/null 2>&1; then
        echo "🔎 Ejecutando Maigret..." | tee -a "$archivo"
        maigret "$dato" --json | tee -a "$archivo"
    fi
    if command -v scylla >/dev/null 2>&1; then
        echo "🔎 Ejecutando Scylla..." | tee -a "$archivo"
        scylla -q "$dato" | tee -a "$archivo"
    fi
    echo "🔎 Búsqueda manual: https://www.google.com/search?q=\"$dato\"" | tee -a "$archivo"
    exit 0
fi

echo "❌ Formato inválido o dato desconocido" | tee -a "$archivo"
