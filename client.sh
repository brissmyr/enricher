#!/bin/bash

# Usage function to print script usage
function usage {
  echo "Usage: $0 <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  create-plugin <name> <code> - Create a new plugin with the given name and code"
  echo "  list-plugins - List all plugins"
  echo "  update-plugin <id> <code> - Update the code of the plugin with the given ID"
  echo "  delete-plugin <id> - Delete the plugin with the given ID"
  echo "  enrich <event> - Enrich the given event using the configured plugins"
  echo ""
  echo "Examples:"
  echo "  $0 create-plugin my-plugin 'function myPlugin(event, context) { return \"Hello, World!\"; }'"
  echo "  $0 list-plugins"
  echo "  $0 update-plugin 1 'function myPlugin(event, context) { return \"Hello, World!\"; }'"
  echo "  $0 delete-plugin 1"
  echo "  $0 enrich '{\"type\": \"user_action\", \"properties\": {\"custom_ip\": \"8.8.8.8\"}}'"
}

# Check for command-line arguments
if [ $# -lt 1 ]; then
  usage
  exit 1
fi

# Process command-line arguments
case $1 in
  create-plugin)
    # Check for correct number of arguments
    if [ $# -lt 3 ]; then
      usage
      exit 1
    fi

    # Send POST request to create plugin
    curl -X POST -H "Content-Type: application/json" \
      -d "{\"name\": \"$2\", \"code\": \"$3\"}" \
      http://localhost:4567/plugins
    ;;
  list-plugins)
    # Send GET request to list plugins
    curl -X GET http://localhost:4567/plugins
    ;;
  update-plugin)
    # Check for correct number of arguments
    if [ $# -lt 3 ]; then
      usage
      exit 1
    fi

    # Send PUT request to update plugin
    curl -X PUT -H "Content-Type: application/json" \
      -d "{\"code\": \"$3\"}" \
      http://localhost:4567/plugins/$2
    ;;
  delete-plugin)
    # Check for correct number of arguments
    if [ $# -lt 2 ]; then
      usage
      exit 1
    fi

    # Send DELETE request to delete plugin
    curl -X DELETE http://localhost:4567/plugins/$2
    ;;
  enrich)
    # Check for correct number of arguments
    if [ $# -lt 2 ]; then
      usage
      exit 1
    fi

    # Send POST request to enrich event
    curl -X POST -H "Content-Type: application/json" \
      -d "$2" \
      http://localhost:4567/enrich
    ;;
  *)
    usage
    exit 1
    ;;
esac
