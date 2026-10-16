#!/bin/bash

# --- CONFIGURACIÓN DE CREDENCIALES ---
FB_TOKEN="TU_TOKEN_DE_FACEBOOK"
INSTA_ID="TU_ID_DE_INSTAGRAM"
TIKTOK_TOKEN="TU_TOKEN_DE_TIKTOK"

clear
echo "=========================================="
echo "    AUDITORÍA ACTIVA: SOCIAL MEDIA API    "
echo "=========================================="

# 1. EJECUCIÓN FACEBOOK
echo -e "\n[*] Interrogando Graph API (Facebook)..."
FB_RES=$(curl -s -X GET "https://graph.facebook.com/v19.0/me?fields=id,name&access_token=${FB_TOKEN}")
if echo "$FB_RES" | grep -q "error"; then
    echo "[-] Error en FB: $(echo "$FB_RES" | jq -r '.error.message')"
else
    echo "[+] Perfil: $(echo "$FB_RES" | jq -r '.name') (ID: $(echo "$FB_RES" | jq -r '.id'))"
fi

# 2. EJECUCIÓN INSTAGRAM
echo -e "\n[*] Interrogando Graph API (Instagram)..."
INSTA_RES=$(curl -s -X GET "https://graph.facebook.com/v19.0/${INSTA_ID}/media?fields=caption,media_type&access_token=${FB_TOKEN}")
if echo "$INSTA_RES" | grep -q "error"; then
    echo "[-] Error en IG: $(echo "$INSTA_RES" | jq -r '.error.message')"
else
    echo "[+] Últimos posts del feed:"
    echo "$INSTA_RES" | jq -r '.data[] | "- [\(.media_type)] \(.caption)"'
fi

# 3. EJECUCIÓN TIKTOK
echo -e "\n[*] Interrogando Open API (TikTok)..."
TK_RES=$(curl -s -X GET "https://open.tiktokapis.com/v2/user/info/?fields=display_name,avatar_url" \
     -H "Authorization: Bearer ${TIKTOK_TOKEN}")
if echo "$TK_RES" | grep -q "error"; then
    echo "[-] Error en TikTok: $(echo "$TK_RES" | jq -r '.error.message')"
else
    echo "[+] Usuario TikTok: $(echo "$TK_RES" | jq -r '.data.user.display_name')"
fi
echo "=========================================="
