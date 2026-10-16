cat << 'EOF' > ~/auto_sync_github.sh
#!/bin/bash
echo "🔄 Sincronizando repositorios con GitHub..."

repos=(
    "bunker-security-toolkit"
    "python-security-arsenal"
    "termux-automation-scripts"
    "osint-recon-toolkit"
)

for repo in "${repos[@]}"; do
    if [ -d "$HOME/$repo" ]; then
        echo "----------------------------------------"
        echo "📌 Procesando: $repo"
        cd "$HOME/$repo"
        if [ -n "$(git status --porcelain)" ]; then
            git add .
            git commit -m "auto: actualización y sincronización del laboratorio ($(date +'%Y-%m-%d %H:%M'))"
            git push origin main
            echo "✅ $repo sincronizado."
        else
            echo "ℹ️  Sin cambios pendientes en $repo."
        fi
    fi
done

cd ~
echo "----------------------------------------"
echo "🚀 Sincronización global completada."
EOF

chmod +x ~/auto_sync_github.sh

