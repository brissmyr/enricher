#!/bin/bash

# Command line interface to interact with the Enricher API

HOST=localhost:4567

usage() {
  echo "Usage: $0 <command> [<args>]"
  echo ""
  echo "Available commands:"
  echo "  enrich <ip>  Enriches an event with the given IP address"
  echo "  list         Lists all plugins"
  echo "  create       Creates a new plugin"
  echo ""
  echo "Run '$0 <command> --help' for more information on a command."
  exit 1
}

enrich() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 enrich <ip>"
    exit 1
  fi

  curl -X POST -H "Content-Type: application/json" \
    -d "{\"properties\":{\"custom_ip\":\"$1\"}}" \
    http://$HOST/enrich | jq
}

list() {
  curl http://$HOST/list | jq
}

create() {
  if [ $# -ne 2 ]; then
    echo "Usage: $0 create <name> <code>"
    exit 1
  fi

  curl -X POST -H "Content-Type: application/json" \
    -d "{\"name\":\"$1\",\"code\":\"$2\"}" \
    http://$HOST/plugins

  echo "Plugin created"
}

if [ $# -lt 1 ]; then
  usage
fi

case $1 in
  enrich)
    shift
    enrich $@
    ;;
  list)
    list
    ;;
  create)
    shift
    create $@
    ;;
  *)
    usage
    ;;
esac
