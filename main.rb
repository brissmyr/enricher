require 'json'
require_relative 'enrich'

# Sample input event
event = {
  properties: {
    custom_ip: '8.8.8.9'
  }
}

result = Enrich.run(event)

puts JSON.pretty_generate(result)
