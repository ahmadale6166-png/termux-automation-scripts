#!/bin/bash
TIKTOK_URL="https://open-api.tiktokglobalshop.com/analytics?access_token=TU_ACCESS_TOKEN"
METRICAS=$(curl -s "$TIKTOK_URL" | jq '.data')

echo "$(date '+%Y-%m-%d %H:%M') - Métricas TikTok: $METRICAS" >> log_tiktok.txt
