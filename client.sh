#!/bin/sh

url="http://localhost:4567"

if [ "$1" = "enrich" ]; then
  curl \
    -s \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{
          "properties": {
            "custom_ip": "8.8.8.9"
          }
        }' \
    "$url/enrich" | jq
elif [ "$1" = "list" ]; then
  curl \
    -s \
    "$url/list" | jq
else
  echo "Invalid argument: $1"
fi
