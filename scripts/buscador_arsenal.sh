#!/bin/bash

BASE_DIR="$HOME"

clear
echo "=========================================="
echo "   INDEXADOR Y BUSCADOR DE ARSENAL"
echo "=========================================="
echo "1. Buscar herramienta propia y ejecutar"
echo "2. Listar mis scripts principales (.sh / .py)"
echo "3. Salir"
echo "------------------------------------------"
read -p "Selecciona una opción (1-3): " opcion

case $opcion in
    1)
        read -p "Ingresa el nombre o parte de la herramienta a buscar: " termino
        echo -e "\n[*] Buscando '$termino'...\n"
        
        TEMP_LIST=$(mktemp)
        find "$BASE_DIR" -iname "*$termino*" \
            -not -path '*/.*' \
            -not -path '*/tools*' \
            -not -path '*/node_modules*' \
            -not -path '*/vendor*' 2>/dev/null | head -n 40 > "$TEMP_LIST"
        
        i=1
        declare -A rutas
        while IFS= read -r archivo; do
            rutas[$i]="$archivo"
            if [ -x "$archivo" ]; then
                echo "[$i] 🟢 [Ejecutable] $archivo"
            elif [[ "$archivo" == *.sh ]]; then
                echo "[$i] 🔵 [Bash Script]  $archivo"
            elif [[ "$archivo" == *.py ]]; then
                echo "[$i] 🟡 [Python Script] $archivo"
            else
                echo "[$i] 📄 [Archivo]      $archivo"
            fi
            i=$((i+1))
        done < "$TEMP_LIST"
        
        total=$((i-1))
        if [ $total -eq 0 ]; then
            echo "❌ No se encontraron resultados para '$termino'."
            rm "$TEMP_LIST"
            exit 0
        fi
        
        echo ""
        read -p "Ingresa el número de la herramienta que deseas ejecutar (0 para cancelar): " seleccion
        
        if [[ "$seleccion" =~ ^[0-9]+$ ]] && [ "$seleccion" -gt 0 ] && [ "$seleccion" -le "$total" ]; then
            archivo_elegido="${rutas[$seleccion]}"
            echo -e "\n[+] Ejecutando: $archivo_elegido\n"
            echo "------------------------------------------"
            
            if [[ "$archivo_elegido" == *.py ]]; then
                python3 "$archivo_elegido"
            elif [[ "$archivo_elegido" == *.sh ]]; then
                bash "$archivo_elegido"
            elif [ -x "$archivo_elegido" ]; then
                "$archivo_elegido"
            else
                read -p "⚠️ No es un ejecutable directo. ¿Deseas abrirlo con nano? (s/n): " abrir
                if [ "$abrir" == "s" ]; then
                    nano "$archivo_elegido"
                else
                    cat "$archivo_elegido"
                fi
            fi
        else
            echo "Operación cancelada."
        fi
        
        rm "$TEMP_LIST"
        ;;
    2)
        echo -e "\n=== MIS SCRIPTS DE BASH (.sh) ==="
        find "$BASE_DIR" -name "*.sh" \
            -not -path '*/.*' \
            -not -path '*/tools*' \
            -not -path '*/node_modules*' \
            -not -path '*/vendor*' 2>/dev/null | head -n 30
        
        echo -e "\n=== MIS SCRIPTS DE PYTHON (.py) ==="
        find "$BASE_DIR" -name "*.py" \
            -not -path '*/.*' \
            -not -path '*/tools*' \
            -not -path '*/node_modules*' \
            -not -path '*/vendor*' 2>/dev/null | head -n 30
        ;;
    3)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "Opción no válida."
        ;;
esac
