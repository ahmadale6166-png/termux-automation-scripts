#!/bin/bash
URL="https://group/guest/surveys?token=TU_TOKEN"
RESP=$(curl -s "$URL")

if echo "$RESP" | grep -q "NoSurveysAvailable"; then
  echo "$(date) - Sin encuestas" >> log_encuestas.txt
else
  echo "$(date) - Encuestas disponibles!" >> log_encuestas.txt
  termux-notification \
    --title "Encuestas" \
    --content "¡Encuestas disponibles ahora!" \
    --priority high \
    --sound
fi
