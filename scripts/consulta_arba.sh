#!/bin/bash
tema=$(echo "$1" | sed 's/ /+/g')
curl -s "https://api.openalex.org/works?search=$tema" | jq '.results[].title' > resultados.txt
grep -i "Buenos Aires\|Argentina" resultados.txt
