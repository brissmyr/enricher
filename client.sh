#!/bin/sh

curl \
  -s \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
        "properties": {
          "custom_ip": "8.8.8.9"
        }
      }' \
  http://localhost:4567/enrich | jq
