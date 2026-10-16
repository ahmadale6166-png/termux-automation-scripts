#!/bin/bash
# Script para validar formato de DNI, CUIL, CBU y teléfono argentino

dato="$1"

# Validar DNI (7 u 8 dígitos)
if echo "$dato" | grep -qE '^[0-9]{7,8}$'; then
    echo "✅ DNI válido (formato correcto)"
    exit 0
fi

# Validar CUIL (11 dígitos)
if echo "$dato" | grep -qE '^[0-9]{11}$'; then
    echo "✅ CUIL válido (formato correcto)"
    exit 0
fi

# Validar CBU (22 dígitos)
if echo "$dato" | grep -qE '^[0-9]{22}$'; then
    echo "✅ CBU válido (formato correcto)"
    exit 0
fi

# Validar Teléfono argentino (+549 seguido de 10 dígitos)
if echo "$dato" | grep -qE '^\+549[0-9]{10}$'; then
    echo "✅ Teléfono válido (formato correcto)"
    exit 0
fi

# Si no coincide con nada
echo "❌ Formato inválido o dato desconocido"
